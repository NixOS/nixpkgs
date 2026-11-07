{
  lib,
  pkg-config,
  exiv2,
  gettext,
  fetchFromGitHub,
  gitUpdater,
  buildPythonPackage,
  setuptools,
  toml,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "exiv2";
  version = "0.19.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "python-exiv2";
    tag = finalAttrs.version;
    hash = "sha256-o7COS308ALPYgcQtKGrgwx+4KLGlsZ29J1LSrAldTw4=";
  };

  build-system = [
    setuptools
    toml
  ];
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    exiv2
    gettext
  ];

  pythonImportsCheck = [ "exiv2" ];
  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Low level Python interface to the Exiv2 C++ library";
    homepage = "https://github.com/jim-easterbrook/python-exiv2";
    changelog = "https://github.com/jim-easterbrook/python-exiv2/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zebreus ];
  };
})
