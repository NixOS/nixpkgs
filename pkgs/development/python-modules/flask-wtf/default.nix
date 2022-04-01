{ lib, fetchPypi, buildPythonPackage, flask, wtforms, nose }:

buildPythonPackage rec {
  pname = "Flask-WTF";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NP5cb+4PabUOMPgaO36haqFJKncf6a0JdNFkYQwJpsk=";
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
