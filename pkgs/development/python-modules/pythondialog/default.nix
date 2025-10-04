{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pythondialog";
  version = "3.5.3";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b2a34a8af0a6625ccbdf45cd343b854fc6c1a85231dadc80b8805db836756323";
  };

  patchPhase = ''
    substituteInPlace dialog.py --replace ":/bin:/usr/bin" ":$out/bin"
  '';

  meta = with lib; {
    description = "Python interface to the UNIX dialog utility and mostly-compatible programs";
    homepage = "http://pythondialog.sourceforge.net/";
    license = licenses.lgpl3;
  };
}
