{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  build,
  setuptools,

  nose2,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "inotify";
  version = "0.2.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsoprea";
    repo = "PyInotify";
    tag = version;
    hash = "sha256-x6wvrwLDH/9UMTsAIHwCKR5Avv1givlJFFeBM//FOdg=";
  };

  build-system = [
    build
    setuptools
  ];

  nativeCheckInputs = [
    nose2
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/dsoprea/PyInotify";
    description = "Monitor filesystems events on Linux platforms with inotify";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
