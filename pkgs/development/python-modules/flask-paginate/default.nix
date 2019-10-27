{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15plwkmi6i7p85q2vgyvmn0l4c2h7pj4mmiziwghyyqbd1rc0dr2";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = https://github.com/lixxu/flask-paginate;
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
