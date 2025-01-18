{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "para";
  version = "0.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RsMjKunY6p2IbP0IzdESiSICvthkX0C2JVWXukz+8hc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "para" ];

  meta = with lib; {
    description = "Set utilities that ake advantage of python's 'multiprocessing' module to distribute CPU-intensive tasks";
    homepage = "https://pypi.org/project/para";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
