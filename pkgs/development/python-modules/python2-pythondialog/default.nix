{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "python2-pythondialog";
  version = "3.5.1";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad159c7b455d9cb2a5173590656d19a26e9cc208264cfab755f5827070d18613";
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
