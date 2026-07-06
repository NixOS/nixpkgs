{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pylint-plugin-utils,
  pytestCheckHook,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pylint-odoo";
  version = "10.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OCA";
    repo = "pylint-odoo";
    tag = "v${version}";
    hash = "sha256-OVltvmSEsL7F46LlTqJ8PH9BO4iYlFWKFTLv5AcmaVU=";
  };

  pythonRelaxDeps = [
    "pylint-plugin-utils"
    "pylint"
  ];

  build-system = [ setuptools ];

  dependencies = [
    pylint-plugin-utils
  ];

  pythonImportsCheck = [ "pylint_odoo" ];

  env.BUILD_README = true; # Enables more tests

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Odoo plugin for Pylint";
    homepage = "https://github.com/OCA/pylint-odoo";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yajo ];
  };
}
