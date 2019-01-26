{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pgk6ngqzh7lgq2nr6hraqp3z76f3f0kjhai50vxb6j1civ8v3mn";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = https://github.com/lixxu/flask-paginate;
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
