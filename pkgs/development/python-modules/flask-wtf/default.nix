{ lib, fetchPypi, buildPythonPackage, flask, wtforms, nose }:

buildPythonPackage rec {
  pname = "Flask-WTF";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "872fbb17b5888bfc734edbdcf45bc08fb365ca39f69d25dc752465a455517b28";
  };

  propagatedBuildInputs = [ flask wtforms nose ];

  doCheck = false; # requires external service

  meta = with lib; {
    description = "Simple integration of Flask and WTForms.";
    license = licenses.bsd3;
    maintainers = [ maintainers.mic92 ];
    homepage = "https://github.com/lepture/flask-wtf/";
  };
}
