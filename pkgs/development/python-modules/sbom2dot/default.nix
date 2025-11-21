{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lib4sbom,
}:

buildPythonPackage rec {
  pname = "sbom2dot";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = "sbom2dot";
    tag = "v${version}";
    hash = "sha256-g6IAGZCLRVxF0f6JEcxNaAKWYlTDt0zYSchsz6hDgdg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lib4sbom
  ];

  pythonImportsCheck = [
    "sbom2dot"
  ];

  meta = {
    changelog = "https://github.com/anthonyharrison/sbom2dot/releases/tag/${src.tag}";
    description = "Create a dependency graph of the components within a SBOM";
    homepage = "https://github.com/anthonyharrison/sbom2dot";
    license = lib.licenses.asl20;
    mainProgram = "sbom2dot";
    maintainers = [ ];
  };
}
