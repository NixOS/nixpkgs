{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, click, werkzeug, jinja2 }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.12.2";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hfs2jr2m5lr51xd4gblb28rncd0xrpycz6c07cyqsbv4dhl9x29";
  };

  propagatedBuildInputs = [ itsdangerous click werkzeug jinja2 ];

  meta = with stdenv.lib; {
    homepage = http://flask.pocoo.org/;
    description = "A microframework based on Werkzeug, Jinja 2, and good intentions";
    license = licenses.bsd3;
  };
}
