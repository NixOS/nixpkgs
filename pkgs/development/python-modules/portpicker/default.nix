{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  psutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "portpicker";
  version = "1.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vVB/1vlvZe4CeB8uZ06dxsmbv6bjw5mS45FiBMnUMfo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ psutil ];

  pythonImportsCheck = [ "portpicker" ];

  meta = {
    description = "Library to choose unique available network ports";
    mainProgram = "portserver.py";
    homepage = "https://github.com/google/python_portpicker";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
