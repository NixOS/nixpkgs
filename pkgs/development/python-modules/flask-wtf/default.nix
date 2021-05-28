{ stdenv, fetchPypi, buildPythonPackage, flask, wtforms, nose }:

buildPythonPackage rec {
  pname = "Flask-WTF";
  version = "0.14.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "086pvg2x69n0nczcq7frknfjd8am1zdy8qqpva1sanwb02hf65yl";
  };

  propagatedBuildInputs = [ flask wtforms nose ];

  doCheck = false; # requires external service

  meta = with stdenv.lib; {
    description = "Simple integration of Flask and WTForms.";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
    homepage = "https://github.com/lepture/flask-wtf/";
  };
}
