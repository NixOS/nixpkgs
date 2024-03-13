{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pylint-plugin-utils,
  pytestCheckHook,
  setuptools,
  validators,
}:
buildPythonPackage rec {
  pname = "pylint-odoo";
  version = "9.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OCA";
    repo = "pylint-odoo";
    rev = "v${version}";
    hash = "sha256-MXhQO7TsqL+rufI531nHiw4YZhJqZZFk3SAcGk0tl+g=";
  };

  nativeBuildInputs = [
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "pylint-plugin-utils"
    "pylint"
    "validators"
  ];

  build-system = [ setuptools ];

  dependencies = [
    pylint-plugin-utils
    validators
  ];

  pythonImportsCheck = [ "pylint_odoo" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Odoo plugin for Pylint";
    homepage = "https://github.com/OCA/pylint-odoo";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
