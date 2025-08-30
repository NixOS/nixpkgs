{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lib4sbom,
  python-magic,
}:

buildPythonPackage rec {
  pname = "sbom4files";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "sbom4files";
    tag = "v${version}";
    hash = "sha256-2J3JNFtau7U5mNkqxU8Y8wIg2JR7CUZUVX0A4F9tMLs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lib4sbom
    python-magic
  ];

  pythonImportsCheck = [
    "sbom4files"
  ];

  meta = {
    changelog = "https://github.com/anthonyharrison/sbom4files/releases/tag/v${version}";
    description = "SBOM generator for files within a directory";
    homepage = "https://github.com/anthonyharrison/sbom4files";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
