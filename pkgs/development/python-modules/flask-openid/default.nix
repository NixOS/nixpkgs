{ lib
, buildPythonPackage
, fetchPypi
, flask
, python3-openid
, python-openid
, isPy27
}:

buildPythonPackage rec {
  pname = "flask-openid";
  version = "1.2.5";

  src = fetchPypi {
    pname = "Flask-OpenID";
    inherit version;
    sha256 = "5a8ffe1c8c0ad1cc1f5030e1223ea27f8861ee0215a2a58a528cc61379e5ccab";
  };

  propagatedBuildInputs = [
    flask
  ] ++ (if isPy27 then [ python-openid ] else [ python3-openid ]);

  # no tests for repo...
  doCheck = false;

  meta = with lib; {
    description = "OpenID support for Flask";
    homepage = http://github.com/mitsuhiko/flask-openid/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
