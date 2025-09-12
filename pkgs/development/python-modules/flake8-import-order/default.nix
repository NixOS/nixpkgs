{
  lib,
  buildPythonPackage,
  fetchPypi,
  flake8,
  pycodestyle,
  pylama,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flake8-import-order";
  version = "0.19.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "flake8_import_order";
    hash = "sha256-Ezs8VUl2MeQjUHT8mKlQeLuoF4MjefIqMfCtJFW8sLI=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycodestyle ];

  nativeCheckInputs = [
    flake8
    pycodestyle
    pylama
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flake8_import_order" ];

  meta = {
    description = "Flake8 and pylama plugin that checks the ordering of import statements";
    homepage = "https://github.com/PyCQA/flake8-import-order";
    changelog = "https://github.com/PyCQA/flake8-import-order/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
  };
}
