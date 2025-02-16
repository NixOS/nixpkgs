{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  cmake,
  nanobind,
  ninja,
  numpy,
  scikit-build-core,

  # buildInputs
  opencl-headers,
  pybind11,
  darwin,
  ocl-icd,

  # dependencies
  platformdirs,
  pytools,

  # tests
  pytestCheckHook,
}:

let
  os-specific-buildInputs =
    if stdenv.hostPlatform.isDarwin then [ darwin.apple_sdk.frameworks.OpenCL ] else [ ocl-icd ];
in
buildPythonPackage rec {
  pname = "pyopencl";
  version = "2025.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pyopencl";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-wAZBDPMJbTmujP1j7LjK28ZozZaUwKPDPZLZbFFTeAs=";
  };

  build-system = [
    cmake
    nanobind
    ninja
    numpy
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    opencl-headers
    pybind11
  ] ++ os-specific-buildInputs;

  dependencies = [
    numpy
    platformdirs
    pytools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)

    # https://github.com/NixOS/nixpkgs/issues/255262
    cd $out
  '';

  # https://github.com/inducer/pyopencl/issues/784 Note that these failing
  # tests are all the tests that are available.
  doCheck = false;

  pythonImportsCheck = [
    "pyopencl"
    "pyopencl.array"
    "pyopencl.cltypes"
    "pyopencl.compyte"
    "pyopencl.elementwise"
    "pyopencl.tools"
  ];

  meta = {
    description = "Python wrapper for OpenCL";
    homepage = "https://github.com/pyopencl/pyopencl";
    changelog = "https://github.com/inducer/pyopencl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    badPlatforms = [
      # ld: symbol(s) not found for architecture arm64/x86_64
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
