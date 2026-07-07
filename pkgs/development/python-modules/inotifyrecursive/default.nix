{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  inotify-simple,
}:

buildPythonPackage rec {
  pname = "inotifyrecursive";
  version = "0.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "osRQsxdpPkU4QW+Q6x14WFBtr+a4uIUDe9LdmuLa+h4=";
  };

  build-system = [ setuptools ];

  dependencies = [ inotify-simple ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ pname ];

  meta = {
    description = "Simple recursive inotify watches for Python";
    homepage = "https://github.com/letorbi/inotifyrecursive";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ Flakebi ];
  };
}
