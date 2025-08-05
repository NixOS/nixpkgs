{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "nocaselist";
  version = "2.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VXFNqEM/tIQ855dASXfkOF1ePfnkqgD33emD/YdBD+8=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nocaselist" ];

  meta = with lib; {
    description = "Case-insensitive list for Python";
    homepage = "https://github.com/pywbem/nocaselist";
    changelog = "https://github.com/pywbem/nocaselist/blob/${version}/docs/changes.rst";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ freezeboy ];
  };
}
