{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyinotify";
  version = "0.9.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nJmKXXYGyoNQZc2rwBOubGbrnqdqAKHjvG4M/itPcfQ=";
  };

  # No tests distributed
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/seb-m/pyinotify/wiki";
    description = "Monitor filesystems events on Linux platforms with inotify";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
