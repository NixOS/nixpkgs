{
  lib,
  buildPythonPackage,
  chameleon,
  click,
  fetchFromGitHub,
  polib,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lingva";
  version = "5.0.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vacanza";
    repo = "lingva";
    tag = "v${version}";
    hash = "sha256-eGXUBSEO5n5WUENhJ+p5eKTdenBsONUWw1mDax7QcSA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    polib
  ];

  optional-dependencies = {
    chameleon = [ chameleon ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.chameleon;

  pythonImportsCheck = [ "lingva" ];

  meta = with lib; {
    description = "Module with tools to extract translatable texts from your code";
    homepage = "https://github.com/vacanza/lingva";
    changelog = "https://github.com/vacanza/lingva/blob/${src.tag}/changes.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
