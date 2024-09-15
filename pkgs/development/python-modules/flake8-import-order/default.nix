{
  lib,
  buildPythonPackage,
  fetchPypi,
  flake8,
  pycodestyle,
  pylama,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "flake8-import-order";
  version = "0.18.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4jlB+JLaPgwJ1xG6u7DHO8c1JC6bIWtyZhZ1ipINkA4=";
  };

  propagatedBuildInputs = [ pycodestyle ];

  nativeCheckInputs = [
    flake8
    pycodestyle
    pylama
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flake8_import_order" ];

  meta = with lib; {
    description = "Flake8 and pylama plugin that checks the ordering of import statements";
    homepage = "https://github.com/PyCQA/flake8-import-order";
    changelog = "https://github.com/PyCQA/flake8-import-order/blob/${version}/CHANGELOG.rst";
    license = with licenses; [
      lgpl3
      mit
    ];
    maintainers = [ ];
  };
}
