{ lib, buildPythonPackage, pythonOlder, fetchFromGitLab
, gobject-introspection, idna, libsoup, precis-i18n, pygobject3, pyopenssl
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "2.0.2";

  disabled = pythonOlder "3.7";

  # Tests aren't included in PyPI tarball.
  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    rev = "nbxmpp-${version}";
    sha256 = "0z27mxgfk7hvpx0xdrd8g9441rywv74yk7s83zjnc2mc7xvpwhf4";
  };

  buildInputs = [ precis-i18n ];
  propagatedBuildInputs = [ gobject-introspection idna libsoup pygobject3 pyopenssl ];

  pythonImportsCheck = [ "nbxmpp" ];

  meta = with lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
