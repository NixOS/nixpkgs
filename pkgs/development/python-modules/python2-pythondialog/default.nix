{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "python2-pythondialog";
  version = "3.4.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d8k7lxk50imdyx85lv8j98i4c93a71iwpapnl1506rpkbm9qvd9";
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
