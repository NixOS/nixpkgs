{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60b2a696bf63d2bc1c90a5b1a861c280461732b88f079c267dc98021911a007b";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
