{ addOpenGLRunpath
, buildPythonPackage
, cmake
, config
, cudaPackages ? { }
, cudaSupport ? config.cudaSupport or false
, fetchFromGitHub
, fetchpatch
, filelock
, gtest
, lib
, libxml2
, lit
, llvmPackages
, ncurses
, pkgsTargetTarget
, pybind11
, pytest
, pytestCheckHook
, python
, pythonRelaxDepsHook
, torchWithRocm
, zlib
}:

let
  pname = "triton";
  version = "2.0.0";

  inherit (cudaPackages) cuda_cudart backendStdenv;

  # A time may come we'll want to be cross-friendly
  #
  # Short explanation: we need pkgsTargetTarget, because we use string
  # interpolation instead of buildInputs.
  #
  # Long explanation: OpenAI/triton downloads and vendors a copy of NVidia's
  # ptxas compiler. We're not running this ptxas on the build machine, but on
  # the user's machine, i.e. our Target platform. The second "Target" in
  # pkgsTargetTarget maybe doesn't matter, because ptxas compiles programs to
  # be executed on the GPU.
  # Cf. https://nixos.org/manual/nixpkgs/unstable/#sec-cross-infra
  ptxas = "${pkgsTargetTarget.cudaPackages.cuda_nvcc}/bin/ptxas";

  llvm = (llvmPackages.llvm.override {
    llvmTargetsToBuild = [ "NATIVE" "NVPTX" ];
    # Upstream CI sets these too:
    # targetProjects = [ "mlir" ];
    extraCMakeFlags = [
      "-DLLVM_INSTALL_UTILS=ON"
    ];
  });
in
buildPythonPackage {
  inherit pname version;

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9GZzugab+Pdt74Dj6zjlEzjj4BcJ69rzMJmqcVMxsKU=";
  };

  patches = [
    # Prerequisite for llvm15 patch
    (fetchpatch {
      url = "https://github.com/openai/triton/commit/2aba985daaa70234823ea8f1161da938477d3e02.patch";
      hash = "sha256-LGv0+Ut2WYPC4Ksi4803Hwmhi3FyQOF9zElJc/JCobk=";
    })
    (fetchpatch {
      url = "https://github.com/openai/triton/commit/e3941f9d09cdd31529ba4a41018cfc0096aafea6.patch";
      hash = "sha256-A+Gor6qzFlGQhVVhiaaYOzqqx8yO2MdssnQS6TIfUWg=";
    })

    # Source: https://github.com/openai/triton/commit/fc7a8e35819bda632bdcf1cf75fd9abe4d4e077a.patch
    # The original patch adds ptxas binary, so we include our own clean copy
    # Drop with the next update
    ./llvm15.patch

    # TODO: there have been commits upstream aimed at removing the "torch"
    # circular dependency, but the patches fail to apply on the release
    # revision. Keeping the link for future reference
    # Also cf. https://github.com/openai/triton/issues/1374

    # (fetchpatch {
    #   url = "https://github.com/openai/triton/commit/fc7c0b0e437a191e421faa61494b2ff4870850f1.patch";
    #   hash = "sha256-f0shIqHJkVvuil2Yku7vuqWFn7VCRKFSFjYRlwx25ig=";
    # })
  ];

  postPatch = ''
    substituteInPlace python/setup.py \
      --replace \
        '= get_thirdparty_packages(triton_cache_path)' \
        '= os.environ["cmakeFlags"].split()'
  ''
  # Wiring triton=2.0.0 with llcmPackages_rocm.llvm=5.4.3
  # Revisit when updating either triton or llvm
  + ''
    substituteInPlace CMakeLists.txt \
      --replace "nvptx" "NVPTX" \
      --replace "LLVM 11" "LLVM"
    sed -i '/AddMLIR/a set(MLIR_TABLEGEN_EXE "${llvmPackages.mlir}/bin/mlir-tblgen")' CMakeLists.txt
    sed -i '/AddMLIR/a set(MLIR_INCLUDE_DIR ''${MLIR_INCLUDE_DIRS})' CMakeLists.txt
    find -iname '*.td' -exec \
      sed -i \
      -e '\|include "mlir/IR/OpBase.td"|a include "mlir/IR/AttrTypeBase.td"' \
      -e 's|include "mlir/Dialect/StandardOps/IR/Ops.td"|include "mlir/Dialect/Func/IR/FuncOps.td"|' \
      '{}' ';'
    substituteInPlace unittest/CMakeLists.txt --replace "include(GoogleTest)" "find_package(GTest REQUIRED)"
    sed -i 's/^include.*$//' unittest/CMakeLists.txt
    sed -i '/LINK_LIBS/i NVPTXInfo' lib/Target/PTX/CMakeLists.txt
    sed -i '/LINK_LIBS/i NVPTXCodeGen' lib/Target/PTX/CMakeLists.txt
  ''
  # TritonMLIRIR already links MLIRIR. Not transitive?
  # + ''
  #   echo "target_link_libraries(TritonPTX PUBLIC MLIRIR)" >> lib/Target/PTX/CMakeLists.txt
  # ''
  # Already defined in llvm, when built with -DLLVM_INSTALL_UTILS
  + ''
    substituteInPlace bin/CMakeLists.txt \
      --replace "add_subdirectory(FileCheck)" ""

    rm cmake/FindLLVM.cmake
  ''
  +
  (
    let
      # Bash was getting weird without linting,
      # but basically upstream contains [cc, ..., "-lcuda", ...]
      # and we replace it with [..., "-L/run/opengl-driver/lib", "-L$stubs", "-lcuda", ...]
      old = [ "-lcuda" ];
      new = [ "-L${addOpenGLRunpath.driverLink}" ] ++ lib.optionals cudaSupport [ "-L${cuda_cudart}/lib/stubs/" "-lcuda" ];

      quote = x: ''"${x}"'';
      oldStr = lib.concatMapStringsSep ", " quote old;
      newStr = lib.concatMapStringsSep ", " quote new;
    in
    ''
      substituteInPlace python/triton/compiler.py \
        --replace '${oldStr}' '${newStr}'
    ''
  )
  # Triton seems to be looking up cuda.h
  + lib.optionalString cudaSupport ''
    sed -i 's|cu_include_dir = os.path.join.*$|cu_include_dir = "${cuda_cudart}/include"|' python/triton/compiler.py
  '';

  nativeBuildInputs = [
    cmake
    pythonRelaxDepsHook

    # Requires torch (circular dependency) and probably needs GPUs:
    # pytestCheckHook

    # Note for future:
    # These *probably* should go in depsTargetTarget
    # ...but we cannot test cross right now anyway
    # because we only support cudaPackages on x86_64-linux atm
    lit
    llvm
    llvmPackages.mlir
  ];

  buildInputs = [
    gtest
    libxml2.dev
    ncurses
    pybind11
    zlib
  ];

  propagatedBuildInputs = [
    filelock
  ];

  preConfigure = ''
    # Upstream's setup.py tries to write cache somewhere in ~/
    export HOME=$TMPDIR

    # Upstream's github actions patch setup.cfg to write base-dir. May be redundant
    echo "
    [build_ext]
    base-dir=$PWD" >> python/setup.cfg

    # The rest (including buildPhase) is relative to ./python/
    cd python/

    # Work around download_and_copy_ptxas()
    dst_cuda="$PWD/triton/third_party/cuda/bin"
    mkdir -p "$dst_cuda"
  ''
  + lib.optionalString (!cudaSupport) ''
    touch $dst_cuda/ptxas
  ''
  + lib.optionalString cudaSupport ''
    ln -s "${ptxas}" "$dst_cuda/ptxas"

    # Avoid GLIBCXX mismatch with other cuda-enabled python packages
    export CC="${backendStdenv.cc}/bin/cc";
    export CXX="${backendStdenv.cc}/bin/c++";
  '';

  # CMake is run by setup.py instead
  dontUseCmakeConfigure = true;
  cmakeFlags = [
    "-DMLIR_DIR=${llvmPackages.mlir}/lib/cmake/mlir"
  ];

  postFixup =
    let
      ptxasDestination = "$out/${python.sitePackages}/triton/third_party/cuda/bin/ptxas";
    in
    # Setuptools (?) strips runpath and +x flags. Let's just restore the symlink
    ''
      rm -f ${ptxasDestination}
    '' + lib.optionalString cudaSupport ''
      ln -s ${ptxas} ${ptxasDestination}
    '';

  checkInputs = [
    cmake # ctest
  ];
  dontUseSetuptoolsCheck = true;
  preCheck =
    # build/temp* refers to build_ext.build_temp (looked up in the build logs)
    ''
      (cd /build/source/python/build/temp* ; ctest)
    '' # For pytestCheckHook
    + ''
      cd test/unit
    '';
  pythonImportsCheck = [
    # Circular dependency on torch
    # "triton"
    # "triton.language"
  ];

  passthru = {
    inherit cudaSupport;

    # Ultimately, torch is our test suite:
    tests = {
      inherit torchWithRocm;
    };
  };

  pythonRemoveDeps = [
    # Circular dependency, cf. https://github.com/openai/triton/issues/1374
    "torch"

    # CLI tools without dist-info
    "cmake"
    "lit"
  ];
  meta = with lib; {
    description = "Development repository for the Triton language and compiler";
    homepage = "https://github.com/openai/triton/";
    platforms = lib.platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
