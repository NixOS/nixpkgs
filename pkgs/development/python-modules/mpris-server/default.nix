{ lib, fetchPypi, buildPythonPackage, emoji, pygobject3, unidecode, typing-extensions, pydbus }:

buildPythonPackage rec {
  pname = "mpris_server";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wgipcp53nz5klr0cgi0gz2bsnyhz3jmxkmbg1kd8cnf8zrwqyd7";
  };

  propagatedBuildInputs = [
    emoji
    pydbus
    pygobject3
    typing-extensions
    unidecode
  ];

  # no tests available
  #doCheck = false;
  #pythonImportsCheck = [ "pychromecast" ];

  meta = with lib; {
    description = "Publish a MediaPlayer2 MPRIS device to D-Bus.";
    homepage    = "https://github.com/alexdelorenzo/mpris_server/";
    license     = licenses.agpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms   = platforms.unix;
  };
}
