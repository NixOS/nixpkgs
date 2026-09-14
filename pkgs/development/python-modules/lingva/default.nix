{
  lib,
  buildPythonPackage,
  chameleon,
  click,
  fetchFromGitHub,
  polib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lingva";
  version = "5.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vacanza";
    repo = "lingva";
    tag = "v${version}";
    hash = "sha256-jGdDXRNhgF3sy9clx9rg7T2rjYlH7UHm0QsN+HZV0Sk=";
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

  meta = {
    description = "Module with tools to extract translatable texts from your code";
    homepage = "https://github.com/vacanza/lingva";
    changelog = "https://github.com/vacanza/lingva/blob/${src.tag}/changes.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
