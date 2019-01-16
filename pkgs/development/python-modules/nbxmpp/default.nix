{ stdenv, buildPythonPackage, fetchzip, pyopenssl, python }:

let
  pname = "nbxmpp";
  version = "0.6.9";
  name = "${pname}-${version}";
in buildPythonPackage rec {
  inherit pname version;
  # Tests aren't included in PyPI tarball.
  src = fetchzip {
    name = "${name}.tar.bz2";
    url = "https://dev.gajim.org/gajim/python-nbxmpp/repository/archive.tar.bz2?"
        + "ref=${name}";
    sha256 = "14xrq0r5k1dk7rwj4cxyxfapi6gbnqg70mz94g6hn9ij06284mi7";
  };

  propagatedBuildInputs = [ pyopenssl ];

  checkPhase = ''
    # Disable tests requiring networking
    echo "" > test/unit/test_xmpp_transports_nb2.py
    ${python.executable} test/runtests.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
