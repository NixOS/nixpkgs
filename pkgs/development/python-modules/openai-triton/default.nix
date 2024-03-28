{ lib
, config
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, addOpenGLRunpath
, setuptools
, pytestCheckHook
, pythonRelaxDepsHook
, cmake
, ninja
, pybind11
, gtest
, zlib
, ncurses
, libxml2
, lit
, llvm
, filelock
, torchWithRocm
, python
, writeScriptBin

, runCommand

, cudaPackages
, cudaSupport ? config.cudaSupport
}:

let
  mkBinaryStub = name: "${writeScriptBin name ''
    echo binary ${name} is not available: openai-triton was built without CUDA support
  ''}/bin/${name}";
in
buildPythonPackage rec {
  pname = "triton";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    # Release v2.2.0 is not tagged, but published on pypi: https://github.com/openai/triton/issues/3160
    rev = "0e7b97bd47fc4beb21ae960a516cd9a7ae9bc060";
    hash = "sha256-UdxoHkFnFFBfvGa/NvgvGebbtwGYbrAICQR9JZ4nvYo=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
    # pytestCheckHook # Requires torch (circular dependency) and probably needs GPUs:
    cmake
    ninja

    # Note for future:
    # These *probably* should go in depsTargetTarget
    # ...but we cannot test cross right now anyway
    # because we only support cudaPackages on x86_64-linux atm
    lit
    llvm
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
    # openai-triton uses setuptools at runtime:
    # https://github.com/NixOS/nixpkgs/pull/286763/#discussion_r1480392652
    setuptools
  ];

  postPatch = let
    # Bash was getting weird without linting,
    # but basically upstream contains [cc, ..., "-lcuda", ...]
    # and we replace it with [..., "-lcuda", "-L/run/opengl-driver/lib", "-L$stubs", ...]
    old = [ "-lcuda" ];
    new = [ "-lcuda" "-L${addOpenGLRunpath.driverLink}" "-L${cudaPackages.cuda_cudart}/lib/stubs/" ];

    quote = x: ''"${x}"'';
    oldStr = lib.concatMapStringsSep ", " quote old;
    newStr = lib.concatMapStringsSep ", " quote new;
  in ''
    # Use our `cmakeFlags` instead and avoid downloading dependencies
    substituteInPlace python/setup.py \
      --replace "= get_thirdparty_packages(triton_cache_path)" "= os.environ[\"cmakeFlags\"].split()"

    # Already defined in llvm, when built with -DLLVM_INSTALL_UTILS
    substituteInPlace bin/CMakeLists.txt \
      --replace "add_subdirectory(FileCheck)" ""

    # Don't fetch googletest
    substituteInPlace unittest/CMakeLists.txt \
      --replace "include (\''${CMAKE_CURRENT_SOURCE_DIR}/googletest.cmake)" ""\
      --replace "include(GoogleTest)" "find_package(GTest REQUIRED)"
  '' + lib.optionalString cudaSupport ''
    # Use our linker flags
    substituteInPlace python/triton/common/build.py \
      --replace '${oldStr}' '${newStr}'
    # triton/common/build.py will be called both on build, and sometimes in runtime.
    substituteInPlace python/triton/common/build.py \
      --replace 'os.getenv("TRITON_LIBCUDA_PATH")' '"${cudaPackages.cuda_cudart}/lib"'
    substituteInPlace python/triton/common/build.py \
      --replace 'os.environ.get("CC")' '"${cudaPackages.backendStdenv.cc}/bin/cc"'
  '';

  # Avoid GLIBCXX mismatch with other cuda-enabled python packages
  preConfigure = ''
    # Upstream's setup.py tries to write cache somewhere in ~/
    export HOME=$(mktemp -d)

    # Upstream's github actions patch setup.cfg to write base-dir. May be redundant
    echo "
    [build_ext]
    base-dir=$PWD" >> python/setup.cfg

    # The rest (including buildPhase) is relative to ./python/
    cd python

    mkdir -p $out/${python.sitePackages}/triton/third_party/cuda/bin
    function install_binary {
      export TRITON_''${1^^}_PATH=$2
      ln -s $2 $out/${python.sitePackages}/triton/third_party/cuda/bin/
    }
  '' + lib.optionalString cudaSupport ''
    export CC=${cudaPackages.backendStdenv.cc}/bin/cc;
    export CXX=${cudaPackages.backendStdenv.cc}/bin/c++;

    install_binary ptxas ${cudaPackages.cuda_nvcc}/bin/ptxas
    install_binary cuobjdump ${cudaPackages.cuda_cuobjdump}/bin/cuobjdump
    install_binary nvdisasm ${cudaPackages.cuda_nvdisasm}/bin/nvdisasm
  '' + lib.optionalString (!cudaSupport) ''
    install_binary ptxas ${mkBinaryStub "ptxas"}
    install_binary cuobjdump ${mkBinaryStub "cuobjdump"}
    install_binary nvdisasm ${mkBinaryStub "nvdisasm"}
  '';

  # CMake is run by setup.py instead
  dontUseCmakeConfigure = true;

  checkInputs = [ cmake ]; # ctest
  dontUseSetuptoolsCheck = true;

  preCheck = ''
    # build/temp* refers to build_ext.build_temp (looked up in the build logs)
    (cd /build/source/python/build/temp* ; ctest)

    # For pytestCheckHook
    cd test/unit
  '';

  # Circular dependency on torch
  # pythonImportsCheck = [
  #   "triton"
  #   "triton.language"
  # ];

  # Ultimately, torch is our test suite:
  passthru.tests = {
    inherit torchWithRocm;
    # Implemented as alternative to pythonImportsCheck, in case if circular dependency on torch occurs again,
    # and pythonImportsCheck is commented back.
    import-triton = runCommand "import-triton" { nativeBuildInputs = [(python.withPackages (ps: [ps.openai-triton]))]; } ''
      python << \EOF
      import triton
      import triton.language
      EOF
      touch "$out"
    '';
  };

  pythonRemoveDeps = [
    # Circular dependency, cf. https://github.com/openai/triton/issues/1374
    "torch"

    # CLI tools without dist-info
    "cmake"
    "lit"
  ];

  meta = with lib; {
    description = "Language and compiler for writing highly efficient custom Deep-Learning primitives";
    homepage = "https://github.com/openai/triton";
    platforms = lib.platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge Madouura ];
  };
}
