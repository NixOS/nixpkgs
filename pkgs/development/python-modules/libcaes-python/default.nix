{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "libcaes-python";
  version = "20240413";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L39X0Y65cRAkATLVxS+v32A7VNeVL6uJVOBHENNlDqo=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pycaes" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libcaes/releases/tag/${version}";
    description = "Python bindings module for libcaes";
    downloadPage = "https://github.com/libyal/libcaes/releases";
    homepage = "https://github.com/libyal/libcaes";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
