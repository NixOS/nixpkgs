{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cmake,
  cython,
  ninja,
  numpy,
  scikit-build-core,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  htslib,

  # dependencies
  click,
  coloredlogs,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyvcf2";
  version = "0.34.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "brentp";
    repo = "cyvcf2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XDo2cEcZm5y6u9Gc2e7q2tg8pt3C/5cmnWRe6Dr5x7M=";
  };

  build-system = [
    cmake
    cython
    ninja
    numpy
    scikit-build-core
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    htslib
  ];

  env = {
    # Link against the system htslib instead of building the bundled submodule
    CYVCF2_HTSLIB_MODE = "EXTERNAL";
  };

  dependencies = [
    click
    coloredlogs
    numpy
  ];

  pythonImportsCheck = [ "cyvcf2" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # The test suite lives inside the package directory and relies on relative imports
  # (`from ..cyvcf2 import VCF`) as well as data files next to it, so it must run from the source
  # tree. Bring the compiled extension along.
  preCheck = ''
    cp $out/${python.sitePackages}/cyvcf2/cyvcf2*.so cyvcf2/
  '';

  meta = {
    description = "Cython wrapper around htslib built for fast parsing of Variant Call Format (VCF) files";
    homepage = "https://github.com/brentp/cyvcf2";
    changelog = "https://github.com/brentp/cyvcf2/blob/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
