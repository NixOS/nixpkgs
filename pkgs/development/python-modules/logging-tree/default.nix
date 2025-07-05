{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "logging-tree";
  version = "1.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "brandon-rhodes";
    repo = "logging_tree";
    tag = version;
    hash = "sha256-9MeCx708EUe5dmFkol+HISzdBX+yar1HjKIAwmg1msA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "logging_tree" ];

  meta = {
    description = "Debug Python logging problems by printing out the tree of handlers you have defined";
    homepage = "https://github.com/brandon-rhodes/logging_tree";
    license = [ lib.licenses.bsd2 ];
    maintainers = [ lib.maintainers.rskew ];
  };
}
