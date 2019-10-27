{ stdenv, buildPythonPackage, fetchzip, pyopenssl, python }:

let
  pname = "nbxmpp";
  version = "0.6.10";
  name = "${pname}-${version}";
in buildPythonPackage {
  inherit pname version;
  # Tests aren't included in PyPI tarball.
  src = fetchzip {
    name = "${name}.tar.bz2";
    url = "https://dev.gajim.org/gajim/python-nbxmpp/repository/archive.tar.bz2?"
        + "ref=${name}";
    sha256 = "1w31a747mj9rvlp3n20z0fnvyvihphkgkyr22sk2kap3migw8vai";
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
