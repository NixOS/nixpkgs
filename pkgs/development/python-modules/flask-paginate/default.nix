{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60079a1c4c600cb4d4a9f7c386ea357b5ee02355ae6d6e8b41f769ae3f7af3ad";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = https://github.com/lixxu/flask-paginate;
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
