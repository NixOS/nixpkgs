{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csaf-tool,
  lib4sbom,
  packageurl-python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lib4vex";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "lib4vex";
    tag = "v${version}";
    hash = "sha256-XH3Y2kbsJFR202F8bmcd3IWpgHS36W+ylDObtBFNFFg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    csaf-tool
    lib4sbom
    packageurl-python
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "lib4vex" ];

  meta = {
    description = "Library to ingest and generate VEX documents";
    homepage = "https://github.com/anthonyharrison/lib4vex";
    changelog = "https://github.com/anthonyharrison/lib4vex/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ teatwig ];
  };
}
