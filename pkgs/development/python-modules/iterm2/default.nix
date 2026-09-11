{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  pytestCheckHook,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "iterm2";
  version = "2.20";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Fo04B81Ys+Z4R2hSviu0pc2J8AjZXjfSd32YEHMc/wg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    protobuf
    websockets
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "iterm2" ];

  meta = {
    description = "Python interface to iTerm2's scripting API";
    homepage = "https://github.com/gnachman/iTerm2";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ jeremyschlatter ];
  };
}
