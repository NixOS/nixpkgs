{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "pyotp";
  version = "2.7.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zpifq6Dfd9wDK0XlHGzKQrzyCJbI09HnzXWaU9x9bLU=";
  };

  pythonImportsCheck = [ "pyotp" ];

  meta = with lib; {
    description = "Python One Time Password Library";
    homepage = "https://github.com/pyauth/pyotp";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
