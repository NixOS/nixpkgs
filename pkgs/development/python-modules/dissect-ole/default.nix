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
  version = "3.11";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ole";
    tag = version;
    hash = "sha256-KdqEZxZ2V3AKHgpHfXmnw4sh+P8ZPOMvbRq0xENwiX8=";
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
