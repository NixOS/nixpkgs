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
  version = "5.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vacanza";
    repo = "lingva";
    rev = "refs/tags/v${version}";
    hash = "sha256-kr64L/DtEWZu9z2p90QJHnb/6LygwZgxE+rARbo0NYI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chameleon
    click
    polib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lingva" ];

  meta = with lib; {
    description = "Module with tools to extract translatable texts from your code";
    homepage = "https://github.com/vacanza/lingva";
    changelog = "https://github.com/vacanza/lingva/blob/${version}/changes.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
