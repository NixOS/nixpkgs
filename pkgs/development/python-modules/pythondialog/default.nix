{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pythondialog";
  version = "3.4.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1728ghsran47jczn9bhlnkvk5bvqmmbihabgif5h705b84r1272c";
  };

  patchPhase = ''
    substituteInPlace dialog.py --replace ":/bin:/usr/bin" ":$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "A Python interface to the UNIX dialog utility and mostly-compatible programs";
    homepage = "http://pythondialog.sourceforge.net/";
    license = licenses.lgpl3;
  };

}
