{ lib
, buildPythonPackage
, fetchFromGitLab
, gobject-introspection
, idna
, libsoup_3
, packaging
, precis-i18n
, pygobject3
, pyopenssl
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "4.5.3";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    rev = "refs/tags/${version}";
    hash = "sha256-vAuHfG2/DVUDCxUb7UMRejIh4fQHGl67A+dncvcJ8jQ=";
  };

  nativeBuildInputs = [
    # required for pythonImportsCheck otherwise libsoup cannot be found
    gobject-introspection
    setuptools
  ];

  buildInputs = [
    precis-i18n
  ];

  propagatedBuildInputs = [
    gobject-introspection
    idna
    libsoup_3
    packaging
    pygobject3
    pyopenssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nbxmpp"
  ];

  meta = with lib; {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
