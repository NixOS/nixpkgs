{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "949b93d0535d1223b91ac0048586bd878aaebf4044c54c1dc3068acc9bdf441f";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
