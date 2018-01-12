{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, click, werkzeug, jinja2, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.12.2";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hfs2jr2m5lr51xd4gblb28rncd0xrpycz6c07cyqsbv4dhl9x29";
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
