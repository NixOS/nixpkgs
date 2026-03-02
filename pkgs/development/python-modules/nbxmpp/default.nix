{
  lib,
  buildPythonPackage,
  fetchurl,
  fetchFromGitLab,
  gobject-introspection,
  idna,
  libsoup_3,
  packaging,
  precis-i18n,
  pygobject3,
  pyopenssl,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    tag = version;
    hash = "sha256-NzSXvuPf7PZbMPgD3nhPgTH4Vd8DVx49fjf7cPcvywc=";
  };

  nativeBuildInputs = [
    # required for pythonImportsCheck otherwise libsoup cannot be found
    gobject-introspection
    setuptools
  ];

  buildInputs = [ precis-i18n ];

  propagatedBuildInputs = [
    gobject-introspection
    idna
    libsoup_3
    packaging
    pygobject3
    pyopenssl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nbxmpp" ];

  meta = {
    homepage = "https://dev.gajim.org/gajim/python-nbxmpp";
    description = "Non-blocking Jabber/XMPP module";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
