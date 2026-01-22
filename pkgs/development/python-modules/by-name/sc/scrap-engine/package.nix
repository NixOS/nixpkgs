{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "scrap-engine";
  version = "1.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "scrap_engine";
    inherit version;
    hash = "sha256-olTWIr1gqy+TgupmKhYJSA83voWyqFxxTQquqJpbt7s=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "scrap_engine" ];

  # raise scrap_engine.CoordinateError
  doCheck = false;

  meta = {
    maintainers = with lib.maintainers; [ fgaz ];
    description = "2D ascii game engine for the terminal";
    homepage = "https://github.com/lxgr-linux/scrap_engine";
    license = lib.licenses.gpl3Only;
  };
}
