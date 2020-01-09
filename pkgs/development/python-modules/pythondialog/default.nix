{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pythondialog";
  version = "3.5.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "34a0687290571f37d7d297514cc36bd4cd044a3a4355271549f91490d3e7ece8";
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
