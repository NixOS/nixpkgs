{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31133c29c718aed95276425f7795d0a32b8d45a992ddd359c69600f22f869254";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
