{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "objprint";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gaogaotiantian";
    repo = "objprint";
    rev = version;
    hash = "sha256-IGYjDdi3JzYk53ITVOhVnm9EDsa+4HXSVtVUE3wQWTo=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "objprint"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library that can print Python objects in human readable format";
    homepage = "https://github.com/gaogaotiantian/objprint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
