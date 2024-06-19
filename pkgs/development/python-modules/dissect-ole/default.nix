{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-ole";
  version = "3.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ole";
    rev = "refs/tags/${version}";
    hash = "sha256-VWbgQhKV1vJBRQROrJXbJ7qDIVOfZwvjsRwUbm7q7OQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "dissect.ole" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Object Linking & Embedding (OLE) format";
    homepage = "https://github.com/fox-it/dissect.ole";
    changelog = "https://github.com/fox-it/dissect.ole/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
