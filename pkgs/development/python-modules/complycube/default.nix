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
  version = "1.1.9";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "complycube";
    hash = "sha256-ZcttKDUb2HEzfxbjHi2gb12UJCcbZCYUlpIf4KObQB8=";
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
