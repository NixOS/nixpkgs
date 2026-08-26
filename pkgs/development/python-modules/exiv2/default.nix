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
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "python-exiv2";
    tag = finalAttrs.version;
    hash = "sha256-BIRIq5k4H+n+8d8B4lpr5VpfXA2JkcI54ZPPWDYtajQ=";
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
