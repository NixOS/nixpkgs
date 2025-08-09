{
  lib,
  stdenv,
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

  #  AttributeError: Can't get local object 'test_output_queue_size.<locals>.get_the_a'
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Set utilities that ake advantage of python's 'multiprocessing' module to distribute CPU-intensive tasks";
    homepage = "https://pypi.org/project/para";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
