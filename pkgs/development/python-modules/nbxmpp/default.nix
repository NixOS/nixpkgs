{ stdenv, buildPythonPackage, fetchzip, pyopenssl, python }:

let
  pname = "nbxmpp";
  version = "0.6.8";
  name = "${pname}-${version}";
in buildPythonPackage rec {
  inherit pname version;
  # Tests aren't included in PyPI tarball.
  src = fetchzip {
    name = "${name}.tar.bz2";
    url = "https://dev.gajim.org/gajim/python-nbxmpp/repository/archive.tar.bz2?"
        + "ref=${name}";
    sha256 = "09zrqz01j45kvayfscd66avkrnn237lbjg9li5hjhyw92h6hkkc4";
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
