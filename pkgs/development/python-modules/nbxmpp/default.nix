{ lib, buildPythonPackage, fetchzip, gobject-introspection, idna, libsoup, precis-i18n, pygobject3, pyopenssl }:

let
  pname = "nbxmpp";
  version = "1.0.2";
  name = "${pname}-${version}";
in buildPythonPackage {
  inherit pname version;
  # Tests aren't included in PyPI tarball.
  src = fetchzip {
    name = "${name}.tar.bz2";
    url = "https://dev.gajim.org/gajim/python-nbxmpp/repository/archive.tar.bz2?"
        + "ref=${name}";
    sha256 = "1rhzsakqrybzq5j5b9400wjd14pncph47c1ggn5a6f3di03lk4az";
  };

  buildInputs = [ precis-i18n ];
  checkInputs = [ gobject-introspection libsoup pygobject3 ];
  propagatedBuildInputs = [ idna pyopenssl ];

  meta = with lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
