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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nbxmpp";
  version = "6.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitLab {
    domain = "dev.gajim.org";
    owner = "gajim";
    repo = "python-nbxmpp";
    rev = "refs/tags/${version}";
    hash = "sha256-q910WbBp0TBqXw8WfYniliVGnr4Hi6dDhVDqZszSL0c=";
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
    (pygobject3.overrideAttrs (o: {
      src = fetchurl {
        url = "mirror://gnome/sources/pygobject/3.52/pygobject-3.52.3.tar.gz";
        hash = "sha256-AOQn0pHpV0Yqj61lmp+ci+d2/4Kot2vfQC8eruwIbYI=";
      };
    }))
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
