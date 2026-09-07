{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cython,
  scikit-build-core,
  cmake,
  ninja,

  # buildInputs
  htslib,

  # dependencies
  click,
  coloredlogs,
  numpy,

  # tests
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "cyvcf2";
  version = "0.34.0";
  src = fetchFromGitHub {
    owner = "brentp";
    repo = "cyvcf2";
    tag = "v${version}";
    hash = "sha256-XDo2cEcZm5y6u9Gc2e7q2tg8pt3C/5cmnWRe6Dr5x7M=";
    fetchSubmodules = false;
  };
  pyproject = true;

  dontUseCmakeConfigure = true;
  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
  ];
  buildInputs = [ htslib ];
  dependencies = [
    click
    coloredlogs
    numpy
  ];

  CYVCF2_HTSLIB_MODE = "EXTERNAL";
  LD_LIBRARY_PATH = (lib.makeLibraryPath buildInputs);

  # copy the build to the test directory to avoid
  # ModuleNotFoundError: 'cyvcf2.cyvcf2'
  preCheck = ''
    cp $out/${python.sitePackages}/cyvcf2/cyvcf2*.so cyvcf2/
  '';
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "cyvcf2" ];

  meta = {
    changelog = "https://github.com/brentp/cyvcf2/blob/main/CHANGES.md";
    description = "cython + htslib == fast VCF and BCF processing";
    homepage = "https://github.com/brentp/cyvcf2/tree/main";
    license = lib.licenses.mit;
    mainProgram = "cyvcf2";
    maintainers = [ ];
  };
}
