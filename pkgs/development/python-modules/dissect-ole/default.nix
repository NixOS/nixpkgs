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
  version = "3.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ole";
    tag = version;
    hash = "sha256-BGJnKL27Sz5CS+PEVK6AeXBuzYpLSA8qR9sz7qeOIWc=";
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
    changelog = "https://github.com/fox-it/dissect.ole/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
