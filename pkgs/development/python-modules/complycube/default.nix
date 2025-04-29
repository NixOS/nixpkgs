{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyhumps,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "complycube";
  version = "1.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "complycube";
    hash = "sha256-hetcn5RX582CRVmtG5dAvr+NXD+7NKJjaqgOo8LlpqM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyhumps
    requests
  ];

  pythonImportsCheck = [ "complycube" ];

  meta = {
    homepage = "https://complycube.com";
    description = "Official Python client for the ComplyCube API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
