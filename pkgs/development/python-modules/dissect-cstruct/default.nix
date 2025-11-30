{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-cstruct";
  version = "4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cstruct";
    tag = version;
    hash = "sha256-eEaKGFpArg0p3+/I2dH3mQ+eNIVJ8KsUbRcw4Ecrl7g=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.cstruct" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for C-like structures";
    homepage = "https://github.com/fox-it/dissect.cstruct";
    changelog = "https://github.com/fox-it/dissect.cstruct/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
