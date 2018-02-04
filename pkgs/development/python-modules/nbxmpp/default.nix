{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10bfb12b083a7509779298c31b4b61e2ed7e78d1960cbcfb3de8d38f3b830991";
  };

  meta = with stdenv.lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3;
  };
}
