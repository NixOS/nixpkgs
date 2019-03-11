{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebc896bf6e8d7a414e3efba0bd0770a8f73dcd7023f99e849c64164287e36e9b";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = https://github.com/lixxu/flask-paginate;
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
