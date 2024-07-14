{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "mullvad-api";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "mullvad_api";
    inherit version;
    hash = "sha256-YcfFR2FVdYo3E/8bqn6ArQniAT/Ddtw6FMXPbZpgEGQ=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "mullvad_api" ];

  meta = with lib; {
    description = "Python client for the Mullvad API";
    homepage = "https://github.com/meichthys/mullvad-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
