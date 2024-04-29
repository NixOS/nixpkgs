{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libfwnt-python";
  version = "20240415";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tDdndZKwW2ymR8Gh2AMUki+mXrb4JaxTByY/+Q0+JJM=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfwnt" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libfwnt/releases/tag/${version}";
    description = "Python bindings module for libfwnt";
    downloadPage = "https://github.com/libyal/libfwnt/releases";
    homepage = "https://github.com/libyal/libfwnt";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
