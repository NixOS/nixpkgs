{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "2022.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a32996ec07ca004c45b768b0d50829728ab8f3986c0650ef538e42852c7aeba2";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
