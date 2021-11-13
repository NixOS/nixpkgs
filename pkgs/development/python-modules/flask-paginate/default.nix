{ lib, buildPythonPackage, fetchPypi, flask }:

buildPythonPackage rec {
  pname = "flask-paginate";
  version = "2021.10.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "660ba1451e4cb168d3a42ed63914fe507bb5c0b30c26a6286b923077bba2362b";
  };

  propagatedBuildInputs = [ flask ];

  meta = with lib; {
    homepage = "https://github.com/lixxu/flask-paginate";
    description = "Pagination support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
