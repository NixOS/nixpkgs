{ lib, buildPythonPackage, fetchPypi, isPy3k
, nose }:

let
  pname = "crccheck";
  version = "1.0";
in buildPythonPackage {
  inherit pname version;

  checkInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ay9lgy80j7lklm07iw2wq7giwnv9fbv50mncblqlc39y322vi0p";
  };

  disabled = !isPy3k;

  meta = with lib; {
    description = "Python library for CRCs and checksums";
    homepage = "https://sourceforge.net/projects/crccheck/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}
