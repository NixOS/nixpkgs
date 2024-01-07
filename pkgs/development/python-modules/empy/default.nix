{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "empy";
  version = "4.0.1";
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YjI3uYzWQ75eILrWJ1zJM//nz3ZFI5Lx0ybXZywqvWQ=";
  };
  pythonImportsCheck = [ "em" ];
  meta = with lib; {
    homepage = "http://www.alcyone.com/software/empy/";
    description = "A templating system for Python.";
    maintainers = with maintainers; [ nkalupahana ];
    license = licenses.lgpl21Only;
  };
}
