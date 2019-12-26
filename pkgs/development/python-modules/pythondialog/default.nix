{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pythondialog";
  version = "3.5.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ydvllwll23qmcd3saachcxzn1dj5if3kc36p37ncf06xc5c0m4";
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
