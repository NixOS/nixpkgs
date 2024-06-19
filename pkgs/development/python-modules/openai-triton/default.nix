{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  addOpenGLRunpath,
  setuptools,
  pytestCheckHook,
  pythonRelaxDepsHook,
  cmake,
  ninja,
  pybind11,
  gtest,
  zlib,
  ncurses,
  libxml2,
  lit,
  llvm,
  filelock,
  torchWithRocm,
  python,

  runCommand,

  cudaPackages,
  cudaSupport ? config.cudaSupport,
}:

let
  ptxas = "${cudaPackages.cuda_nvcc}/bin/ptxas"; # Make sure cudaPackages is the right version each update (See python/setup.py)
in
buildPythonPackage rec {
  pname = "triton";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openai";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8UTUwLH+SriiJnpejdrzz9qIquP2zBp1/uwLdHmv0XQ=";
  };

  patches =
    [
      # fix overflow error
      (fetchpatch {
        url = "https://github.com/openai/triton/commit/52c146f66b79b6079bcd28c55312fc6ea1852519.patch";
        hash = "sha256-098/TCQrzvrBAbQiaVGCMaF3o5Yc3yWDxzwSkzIuAtY=";
      })
    ]
    ++ lib.optionals (!cudaSupport) [
      ./0000-dont-download-ptxas.patch
      # openai-triton wants to get ptxas version even if ptxas is not
      # used, resulting in ptxas not found error.
      ./0001-ptxas-disable-version-key-for-non-cuda-targets.patch
    ];

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

  postPatch =
    let
      # Bash was getting weird without linting,
      # but basically upstream contains [cc, ..., "-lcuda", ...]
      # and we replace it with [..., "-lcuda", "-L/run/opengl-driver/lib", "-L$stubs", ...]
      old = [ "-lcuda" ];
      new = [
        "-lcuda"
        "-L${addOpenGLRunpath.driverLink}"
        "-L${cudaPackages.cuda_cudart}/lib/stubs/"
      ];

      quote = x: ''"${x}"'';
      oldStr = lib.concatMapStringsSep ", " quote old;
      newStr = lib.concatMapStringsSep ", " quote new;
    in
    ''
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
    ''
    + lib.optionalString cudaSupport ''
      # Use our linker flags
      substituteInPlace python/triton/common/build.py \
        --replace '${oldStr}' '${newStr}'
    '';

  # Avoid GLIBCXX mismatch with other cuda-enabled python packages
  preConfigure =
    ''
      # Ensure that the build process uses the requested number of cores
      export MAX_JOBS="$NIX_BUILD_CORES"

      # Upstream's setup.py tries to write cache somewhere in ~/
      export HOME=$(mktemp -d)

      # Upstream's github actions patch setup.cfg to write base-dir. May be redundant
      echo "
      [build_ext]
      base-dir=$PWD" >> python/setup.cfg

      # The rest (including buildPhase) is relative to ./python/
      cd python
    ''
    + lib.optionalString cudaSupport ''
      export CC=${cudaPackages.backendStdenv.cc}/bin/cc;
      export CXX=${cudaPackages.backendStdenv.cc}/bin/c++;

      # Work around download_and_copy_ptxas()
      mkdir -p $PWD/triton/third_party/cuda/bin
      ln -s ${ptxas} $PWD/triton/third_party/cuda/bin
    '';

  # CMake is run by setup.py instead
  dontUseCmakeConfigure = true;

  # Setuptools (?) strips runpath and +x flags. Let's just restore the symlink
  postFixup = lib.optionalString cudaSupport ''
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
  passthru.tests = {
    inherit torchWithRocm;
    # Implemented as alternative to pythonImportsCheck, in case if circular dependency on torch occurs again,
    # and pythonImportsCheck is commented back.
    import-triton =
      runCommand "import-triton"
        { nativeBuildInputs = [ (python.withPackages (ps: [ ps.openai-triton ])) ]; }
        ''
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
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [
      SomeoneSerge
      Madouura
    ];
  };
}
