{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitLab
, gobject-introspection
, idna
, libsoup_3
, precis-i18n
, pygobject3
, pyopenssl
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "4.0.0";

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    rev = version;
    hash = "sha256-6PYJGlNOZMwHMXwf05IWekJ+haMfg+ooH5On+aYOWSI=";
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
    libsoup_3
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
