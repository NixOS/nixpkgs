{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "python2-pythondialog";
  version = "3.3.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yhkagsh99bfi592ymczf8rnw8rk6n9hdqy3dd98m3yrx8zmjvry";
  };

  patchPhase = ''
    substituteInPlace dialog.py --replace ":/bin:/usr/bin" ":$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "A Python interface to the UNIX dialog utility and mostly-compatible programs (Python 2 backport)";
    homepage = "http://pythondialog.sourceforge.net/";
    license = licenses.lgpl3;
  };

}
