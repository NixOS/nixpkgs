{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, addOpenGLRunpath
, pytestCheckHook
, pythonRelaxDepsHook
, pkgsTargetTarget
, cmake
, ninja
, pybind11
, gtest
, zlib
, ncurses
, libxml2
, lit
, filelock
, torchWithRocm
, python
, cudaPackages
}:

let
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
  ptxas = "${pkgsTargetTarget.cudaPackages.cuda_nvcc}/bin/ptxas"; # Make sure cudaPackages is the right version each update (See python/setup.py)
  llvm = callPackage ./llvm.nix { }; # Use a custom llvm, see llvm.nix for details
in
buildPythonPackage rec {
  pname = "triton";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9GZzugab+Pdt74Dj6zjlEzjj4BcJ69rzMJmqcVMxsKU=";
  };

  patches = [
    # TODO: there have been commits upstream aimed at removing the "torch"
    # circular dependency, but the patches fail to apply on the release
    # revision. Keeping the link for future reference
    # Also cf. https://github.com/openai/triton/issues/1374

    # (fetchpatch {
    #   url = "https://github.com/openai/triton/commit/fc7c0b0e437a191e421faa61494b2ff4870850f1.patch";
    #   hash = "sha256-f0shIqHJkVvuil2Yku7vuqWFn7VCRKFSFjYRlwx25ig=";
    # })
  ];

  nativeBuildInputs = [
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

  propagatedBuildInputs = [ filelock ];

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

    # Use our linker flags
    substituteInPlace python/triton/compiler.py \
      --replace '${oldStr}' '${newStr}'

    # Don't fetch googletest
    substituteInPlace unittest/CMakeLists.txt \
      --replace "include (\''${CMAKE_CURRENT_SOURCE_DIR}/googletest.cmake)" ""\
      --replace "include(GoogleTest)" "find_package(GTest REQUIRED)"
  '';

  # Avoid GLIBCXX mismatch with other cuda-enabled python packages
  preConfigure = ''
    export CC=${cudaPackages.backendStdenv.cc}/bin/cc;
    export CXX=${cudaPackages.backendStdenv.cc}/bin/c++;

    # Upstream's setup.py tries to write cache somewhere in ~/
    export HOME=$(mktemp -d)

    # Upstream's github actions patch setup.cfg to write base-dir. May be redundant
    echo "
    [build_ext]
    base-dir=$PWD" >> python/setup.cfg

    # The rest (including buildPhase) is relative to ./python/
    cd python

    # Work around download_and_copy_ptxas()
    mkdir -p $PWD/triton/third_party/cuda/bin
    ln -s ${ptxas} $PWD/triton/third_party/cuda/bin
  '';

  # CMake is run by setup.py instead
  dontUseCmakeConfigure = true;

  # Setuptools (?) strips runpath and +x flags. Let's just restore the symlink
  postFixup = ''
    rm -f $out/${python.sitePackages}/triton/third_party/cuda/bin/ptxas
    ln -s ${ptxas} $out/${python.sitePackages}/triton/third_party/cuda/bin/ptxas
  '';

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
  passthru.tests = { inherit torchWithRocm; };

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
