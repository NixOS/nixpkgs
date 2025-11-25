{
  _cuda,
  boost,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  lib,
  mako,
  numpy,
  platformdirs,
  python,
  pytools,
  setuptools,
  wheel,
  writableTmpDirAsHomeHook,
  writeShellApplication,
  stdenvNoCC,
}:
let
  inherit (_cuda.lib) dropDots;
  inherit (cudaPackages)
    backendStdenv
    cuda_cudart
    cuda_cccl
    cuda_nvcc
    cuda_profiler_api
    libcurand
    ;
  inherit (lib)
    getBin
    getFirstOutput
    getInclude
    getLib
    licenses
    maintainers
    teams
    ;
in
buildPythonPackage {
  __structuredAttrs = true;

  pname = "pycuda";
  version = "2025.1.2";

  pyproject = true;

  stdenv = backendStdenv;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pycuda";
    tag = "v2025.1.2";
    hash = "sha256-JMGVNjiKCAno29df8Zk3njvpgvz9JE8mb0HeJMVTnCQ=";
    # Use the vendored compyte source rather than tracking it as a separate dependency.
    # As an added bonus, this should unbreak the update script added by buildPythonPackage.
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    cuda_nvcc
  ];

  prePatch = ''
    nixLog "removing vendored boost source"
    rm -rf "$PWD/bpl-subset"

    nixLog "patching $PWD/pycuda/compiler.py::compile to fix CUDA include paths"
    substituteInPlace "$PWD/pycuda/compiler.py" \
    --replace-fail \
    'include_dirs = [*include_dirs, _find_pycuda_include_path()]' \
    'include_dirs = [
        *include_dirs,
        "${getInclude cuda_nvcc}/include",
        "${getInclude cuda_cudart}/include",
        "${getInclude cuda_cccl}/include",
        "${getInclude cuda_profiler_api}/include",
        "${getInclude libcurand}/include",
        _find_pycuda_include_path(),
    ]'

    nixLog "patching $PWD/pycuda/compiler.py::compile to fix NVCC path"
    substituteInPlace "$PWD/pycuda/compiler.py" \
      --replace-fail \
        'nvcc="nvcc"' \
        'nvcc="${getBin cuda_nvcc}/bin/nvcc"'

    nixLog "patching $PWD/pycuda/compiler.py::DynamicModule.__init__ to fix CUDA runtime library path"
    substituteInPlace "$PWD/pycuda/compiler.py" \
      --replace-fail \
        'cuda_libdir=None,' \
        'cuda_libdir="${getLib cuda_cudart}/lib",'
  '';

  dependencies = [
    boost
    mako
    numpy
    platformdirs
    pytools
  ];

  buildInputs = [
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    cuda_profiler_api
    libcurand
  ];

  configureScript = "./configure.py";

  # configure.py doesn't support the installation directory arguments _multioutConfig sets.
  # The other argument provided by configurePhase, like --prefix, --enable-shared, and --disable-static are ignored.
  setOutputFlags = false;

  configureFlags = [
    # The expected boost python library name is something like boost_python-py313, but our library name doesn't have a
    # hyphen. The pythonVersion is already a major-minor version, so we just need to remove the dot.
    "--no-use-shipped-boost"
    "--boost-python-libname=boost_python${dropDots python.pythonVersion}"
    # Provide paths to our CUDA libraries.
    "--cudadrv-lib-dir=${getFirstOutput [ "stubs" "lib" ] cuda_cudart}/lib/stubs"
  ];

  # Requires access to libcuda.so.1 which is provided by the driver
  doCheck = false;

  # From setup.py
  pythonImportsCheck = [
    "pycuda"
    # "pycuda.gl" # Requires the CUDA driver
    "pycuda.sparse"
    "pycuda.compyte"
  ];

  # TODO: Split into testers and tests.
  # NOTE: Tests take 23m to run on a 4090 and require 18GB of VRAM.
  passthru = {
    testers.tester = writeShellApplication {
      derivationArgs = {
        __structuredAttrs = true;
        strictDeps = true;
      };
      name = "pycuda-tester";
      runtimeInputs = [
        (python.withPackages (ps: [
          ps.pycuda
          ps.pytest
        ]))
      ];
      text = ''
        echo "Copying pycuda test sources to $PWD/pycuda_test_sources"
        mkdir -p "$PWD/pycuda_test_sources"
        cp -r "${python.pkgs.pycuda.src}"/test "$PWD/pycuda_test_sources"
        chmod -R u+w "$PWD/pycuda_test_sources"

        pushd "$PWD/pycuda_test_sources"
        pytest "$@"
        popd
      '';
    };
    tests =
      let
        makeTest =
          name: testArgs:
          stdenvNoCC.mkDerivation {
            __structuredAttrs = true;
            strictDeps = true;

            inherit name testArgs;

            dontUnpack = true;

            nativeBuildInputs = [
              # cuda_nvcc
              python.pkgs.pycuda.passthru.testers.tester
              writableTmpDirAsHomeHook
            ];

            dontConfigure = true;

            buildPhase = ''
              nixLog "using testArgs: ''${testArgs[*]@Q}"
              pycuda-tester "''${testArgs[@]}" || {
                nixErrorLog "pycuda-tester finished with non-zero exit code: $?"
                exit 1
              }
            '';

            postInstall = ''
              touch $out
            '';

            requiredSystemFeatures = [ "cuda" ];
          };
      in
      {
        # Fast: ~10s on a 4090
        driver = makeTest "pycuda-driver-tests" [ "test/test_driver.py" ];
        # Fast: ~16s on a 4090
        cumath = makeTest "pycuda-cumath-tests" [ "test/test_cumath.py" ];
        # Fast: ~3m on a 4090
        gpuarray-fast = makeTest "pycuda-gpuarray-fast-tests" [
          "test/test_gpuarray.py"
          "-k"
          "not test_curand_wrappers"
        ];
        # EXTREMELY SLOW: ~20m on a 4090
        gpuarray-slow = makeTest "pycuda-gpuarray-slow-tests" [
          "test/test_gpuarray.py"
          "-k"
          "test_curand_wrappers"
        ];
      };
  };

  meta = {
    description = "CUDA integration for Python";
    homepage = "https://github.com/inducer/pycuda/";
    license = licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ connorbaker ];
    teams = [ teams.cuda ];
  };
}
