{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, requests
, cryptography
, importlib-metadata
}:
buildPythonPackage rec {
  pname = "keeper-secrets-manager-core";
  version = "16.6.4";
  pyproject = true;
  src = fetchPypi {
    pname = "keeper-secrets-manager-core";
    inherit version;
    hash = "sha256-msgx3wZmucvqYltfe7UfqWRFrEIFdQvEzSpeD8Lki+Y=";
  };
  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    requests
    cryptography
    importlib-metadata
  ];
  pythonImportsCheck = [ "keeper_secrets_manager_core" ];
  meta = {
    description = "Core library for Keeper Secrets Manager";
    homepage = "https://github.com/Keeper-Security/secrets-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sdubey ];
  };
}
