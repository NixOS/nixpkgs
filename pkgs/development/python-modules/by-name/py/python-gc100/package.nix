{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-gc100";
  version = "1.0.3a0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-thuAmJUczTpKy/yZuVqGY3K3fyimw2PW/rGiyi7bwC4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "gc100" ];

  meta = {
    description = "Python-based socket client for Global Cache GC100 digital I/O interface";
    homepage = "https://github.com/davegravy/python-gc100";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
