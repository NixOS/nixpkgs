{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitLab
, gobject-introspection
, idna
, libsoup
, precis-i18n
, pygobject3
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "3.2.5";

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    rev = version;
    sha256 = "sha256-HIPvZu8Zj69k1FCbkrlSeGtur5cT0TNIYfdXcRbYLwQ=";
  };

  nativeBuildInputs = [
    # required for pythonImportsCheck otherwise libsoup cannot be found
    gobject-introspection
  ];

  buildInputs = [
    precis-i18n
  ];

  propagatedBuildInputs = [
    gobject-introspection
    idna
    libsoup
    pygobject3
    pyopenssl
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nbxmpp" ];

  meta = with lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
