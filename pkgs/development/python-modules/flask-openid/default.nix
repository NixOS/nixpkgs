{ lib, fetchPypi, buildPythonPackage, isPy3k, flask, python-openid, python3-openid }:

buildPythonPackage rec {
  pname = "Flask-OpenID";
  version = "1.2.5";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aycwmwi7ilcaa5ab8hm0bp6323zl8z25q9ha0gwrl8aihfgx3ss";
  };

  # there don't appear to be any tests
  doCheck = false;

  propagatedBuildInputs = [ flask ] ++ (if isPy3k then [ python3-openid ] else [ python-openid ]);

  meta = {
    homepage = "https://github.com/mitsuhiko/flask-openid/";
    description = "OpenID support for Flask";
    license = lib.licenses.bsd3;
  };
}
