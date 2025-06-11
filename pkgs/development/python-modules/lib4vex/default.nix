{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  csaf-tool,
  lib4sbom,
  packageurl-python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lib4vex";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "lib4vex";
    tag = "v${version}";
    hash = "sha256-mR9ZpJDC2O04js3Kd/8qlg4Ds/jy2CmpTywRVYqmnQw=";
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

  meta = with lib; {
    description = "Library to ingest and generate VEX documents";
    homepage = "https://github.com/anthonyharrison/lib4vex";
    changelog = "https://github.com/anthonyharrison/lib4vex/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teatwig ];
  };
}
