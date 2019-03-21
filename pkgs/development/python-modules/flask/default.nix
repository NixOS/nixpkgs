{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, click, werkzeug, jinja2, pytest }:

buildPythonPackage rec {
  version = "1.0.2";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2271c0070dbcb5275fad4a82e29f23ab92682dc45f9dfbc22c02ba9b9322ce48";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ itsdangerous click werkzeug jinja2 ];

  checkPhase = ''
    py.test
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://flask.pocoo.org/;
    description = "A microframework based on Werkzeug, Jinja 2, and good intentions";
    license = licenses.bsd3;
  };
}
