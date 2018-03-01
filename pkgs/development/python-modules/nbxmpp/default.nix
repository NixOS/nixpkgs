{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd66e701a4856e3cace8f4865837ccc9bcfcdb286df01f01aa19531f5d834a83";
  };

  meta = with stdenv.lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3;
  };
}
