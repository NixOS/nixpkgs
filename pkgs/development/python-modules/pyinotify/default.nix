{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyinotify";
  version = "0.9.6";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    pname = "pyinotify";
    inherit (finalAttrs) version;
    hash = "sha256-nJmKXXYGyoNQZc2rwBOubGbrnqdqAKHjvG4M/itPcfQ=";
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
})
