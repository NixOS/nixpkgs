{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "2021.10.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f124390664b2cfd835c54cc884d67fdaa550782a0783576f719fec2379cad193";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
