{ lib, buildPythonPackage, fetchPypi, isPy3k
, nose }:

let
  pname = "crccheck";
  version = "1.1";
in buildPythonPackage {
  inherit pname version;

  checkInputs = [ nose ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "45962231cab62b82d05160553eebd9b60ef3ae79dc39527caef52e27f979fa96";
  };

  disabled = !isPy3k;

  meta = with lib; {
    description = "Python library for CRCs and checksums";
    homepage = "https://sourceforge.net/projects/crccheck/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
