{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  requests,
}:

buildPythonPackage rec {
  pname = "kiwiki-client";
  version = "0.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "c7h";
    repo = "kiwiki_client";
    tag = version;
    hash = "sha256-CIBed8HzbUqUIzNy1lHxIgjneA6R8uKtmd43LU92M0Q=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "kiwiki" ];

  meta = {
    description = "Module to interact with the KIWI.KI API";
    homepage = "https://github.com/c7h/kiwiki_client";
    changelog = "https://github.com/c7h/kiwiki_client/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
