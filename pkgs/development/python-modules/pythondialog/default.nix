{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pythondialog";
  version = "3.5.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4fc11e95540d1d5dbe0a60cd3fb7787354df85ee4b5da21f708ea46cb47bf6d6";
  };

  patchPhase = ''
    substituteInPlace dialog.py --replace ":/bin:/usr/bin" ":$out/bin"
  '';

  meta = with lib; {
    description = "A Python interface to the UNIX dialog utility and mostly-compatible programs";
    homepage = "http://pythondialog.sourceforge.net/";
    license = licenses.lgpl3;
  };

}
