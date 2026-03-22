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
buildPythonPackage rec {
  pname = "exiv2";
  version = "0.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "python-exiv2";
    tag = version;
    hash = "sha256-3r0qGsCkfe2sQuXiCipXzW0vF2JRg77L1IcOiLTPslM=";
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
    changelog = "https://github.com/jim-easterbrook/python-exiv2/blob/${src.tag}/CHANGELOG.txt";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zebreus ];
  };
}
