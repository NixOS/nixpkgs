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
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "4.3.1";

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    rev = version;
    hash = "sha256-8Fh4sgQps6zUEN8o5ljrDIbRlbSZIMncbqh/qAnyOkw=";
  };

  format = "pyproject";

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
    setuptools
  ];

  nativeCheckInputs = [
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
