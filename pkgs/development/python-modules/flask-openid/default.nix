{ lib
, buildPythonPackage
, fetchPypi
, flask
, python3-openid
, isPy3k
}:

buildPythonPackage rec {
  pname = "flask-openid";
  version = "1.2.5";
  disable = !isPy3k;

  src = fetchPypi {
    pname = "Flask-OpenID";
    inherit version;
    sha256 = "5a8ffe1c8c0ad1cc1f5030e1223ea27f8861ee0215a2a58a528cc61379e5ccab";
  };

  propagatedBuildInputs = [
    flask
    python3-openid
  ];

  # no tests for repo...
  doCheck = false;

  meta = with lib; {
    description = "OpenID support for Flask";
    homepage = "https://pythonhosted.org/Flask-OpenID/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
