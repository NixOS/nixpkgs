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
    sha256 = "a96d9cea9a371b5002b5575d1ec351233112519268d382ba6f3582323b3d1335";
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
