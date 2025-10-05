{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "lib4package";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "lib4package";
    tag = "v${version}";
    hash = "sha256-x+JxBH4vfbXaq/e9PlKfkKvJVz2E3kotmsBhR8alhck=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [
    "lib4package"
  ];

  meta = {
    changelog = "https://github.com/anthonyharrison/lib4package/releases/tag/${src.tag}";
    description = "Utility for handling package metadata to include in Software Bill of Materials (SBOMs)";
    homepage = "https://github.com/anthonyharrison/lib4package";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
