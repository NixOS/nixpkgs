{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-git-versioning,
  flipperzero-toolchain,
}:

buildPythonPackage rec {
  pname = "ufbt";
  version = "0.2.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pQI8pSn5X6ISJ2rlEIfe6je4g7PY8HhKITl1GemMvf8=";
  };

  propagatedBuildInputs = [
    setuptools
    setuptools-git-versioning
  ];

  makeWrapperArgs = [
    "--set-default FBT_TOOLCHAIN_PATH ${flipperzero-toolchain}/opt/flipperzero-toolchain"
  ];

  meta = {
    description = "Cross-platform tool for building applications for Flipper Zero";
    mainProgram = "ufbt";
    homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ CodeRadu ];
    platforms = lib.platforms.linux;
  };
}
