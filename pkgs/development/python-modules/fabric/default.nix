{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  decorator,
  deprecated,
  invoke,
  mock,
  paramiko,
  pytestCheckHook,
  pytest-relaxed,
  icecream,
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "3.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h4PKQuOwB28IsmkBqsa52bHxnEEAdOesz6uQLBhP9KM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    invoke
    paramiko
    decorator
    deprecated
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-relaxed
    icecream
    mock
  ];

  # distutils.errors.DistutilsArgError: no commands supplied
  doCheck = false;

  pythonImportsCheck = [ "fabric" ];

  meta = {
    description = "Pythonic remote execution";
    mainProgram = "fab";
    homepage = "https://www.fabfile.org/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
