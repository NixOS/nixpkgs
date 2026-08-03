{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyinotify";
  version = "0.9.6";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x3i9wmzw33fpkis203alygfnrkcmq9w1aydcm887jh6frfqm6cw";
  };

  build-system = [ setuptools ];

  patches = [ ./skip-asyncore-python-3.12.patch ];

  # No tests distributed
  doCheck = false;

  pythonImportsCheck = [ "pyinotify" ];

  meta = {
    homepage = "https://github.com/seb-m/pyinotify/wiki";
    description = "Monitor filesystems events on Linux platforms with inotify";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
