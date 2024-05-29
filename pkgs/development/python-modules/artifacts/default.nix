{
  lib,
  buildPythonPackage,
  fetchPypi,
  pip,
  pythonOlder,
  pyyaml,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "artifacts";
  version = "20230928";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uRjyl35Xl+BuTfERNRumsm2LdEag62TuxrLz+n3xy48=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pip
    pyyaml
  ];

  disabled = pythonOlder "3.8";

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    changelog = "https://github.com/ForensicArtifacts/artifacts/releases/tag/${version}";
    description = "A free, community-sourced, machine-readable knowledge base of forensic artifacts that the world can use both as an information source and within other tools.";
    homepage = "https://github.com/ForensicArtifacts/artifacts";
    downloadPage = "https://github.com/ForensicArtifacts/artifacts/releases";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
