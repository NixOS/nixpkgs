{ lib, buildPythonPackage, fetchPypi, flask, blinker, nose }:

buildPythonPackage rec {
  pname = "Flask-Principal";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lwlr5smz8vfm5h9a9i7da3q1c24xqc6vm9jdywdpgxfbi5i7mpm";
  };

  propagatedBuildInputs = [ flask blinker ];

  nativeCheckInputs = [ nose ];

  meta = with lib; {
    homepage = "http://packages.python.org/Flask-Principal/";
    description = "Identity management for flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
