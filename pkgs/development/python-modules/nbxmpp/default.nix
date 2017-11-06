{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x495yb0abkdspyziw7dyyjwxx6ivnv5zznk92wa3mcind5s9757";
  };

  meta = with stdenv.lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3;
  };
}
