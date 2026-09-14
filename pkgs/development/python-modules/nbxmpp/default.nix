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

buildPythonPackage (finalAttrs: {
  pname = "nbxmpp";
  version = "7.4.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    tag = finalAttrs.version;
    hash = "sha256-Xg2RFEUbvshVDjWftnAx4nbOor1q8naeG2vvukDFwHY=";
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
    changelog = "https://dev.gajim.org/gajim/python-nbxmpp/-/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Non-blocking Jabber/XMPP module";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ haansn08 ];
  };
})
