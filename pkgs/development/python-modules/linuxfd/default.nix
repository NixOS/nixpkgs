{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "linuxfd";
  version = "1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uMABCXJLaOCT+bVW7deOQe1l+42Wn9DoMYape10xObQ=";
  };

  # no tests
  doCheck = false;

  meta = {
    description = "Python bindings for the Linux eventfd/signalfd/timerfd/inotify syscalls";
    homepage = "https://github.com/FrankAbelbeck/linuxfd";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl3Plus;
  };
})
