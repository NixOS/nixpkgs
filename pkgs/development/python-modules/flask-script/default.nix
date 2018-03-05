{ lib, buildPythonPackage, fetchurl, flask, pytest }:

buildPythonPackage rec {
  name = "Flask-Script-${version}";
  version = "2.0.6";

  src = fetchurl {
    url = "mirror://pypi/F/Flask-Script/${name}.tar.gz";
    sha256 = "0zqh2yq8zk7m9b4xw1ryqmrljkdigfb3hk5155a3b5hkfnn6xxyf";
  };

  propagatedBuildInputs = [ flask ];
  checkInputs = [ pytest ];

  meta = with lib; {
    homepage = http://github.com/smurfix/flask-script;
    description = "Scripting support for Flask";
    license = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
