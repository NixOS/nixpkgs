{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pkg-config,
  libgphoto2,
  pytestCheckHook,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "gphoto2";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jim-easterbrook";
    repo = "python-gphoto2";
    tag = "v${version}";
    hash = "sha256-S/uMP2kRXJDetpXT4+MmCvb35xSxEbzhtKJ0PbHIOIU=";
  };

  build-system = [
    setuptools
    toml
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [ libgphoto2 ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "gphoto2" ];

  meta = {
    changelog = "https://github.com/jim-easterbrook/python-gphoto2/blob/${src.tag}/CHANGELOG.txt";
    description = "Python interface to libgphoto2";
    homepage = "https://github.com/jim-easterbrook/python-gphoto2";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
