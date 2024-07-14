{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "linuxfd";
  version = "1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uMABCXJLaOCT+bVW7deOQe1l+42Wn9DoMYape10xObQ=";
  };

  # no tests
  doCheck = false;

  meta = {
    description = "Python bindings for the Linux eventfd/signalfd/timerfd/inotify syscalls";
    homepage = "https://github.com/FrankAbelbeck/linuxfd";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ lgpl3Plus ];
  };
}
