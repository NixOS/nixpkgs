{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "linuxfd";
  version = "1.4.4";


  src = fetchPypi {
    inherit pname version;
    sha256 = "b8bf6847b5c8e50e0842024d2911bfc1048db9abf37582a310cd57070971d692";
  };

  # no tests
  doCheck = false;

  meta = {
    description = "Python bindings for the Linux eventfd/signalfd/timerfd/inotify syscalls";
    homepage = https://github.com/FrankAbelbeck/linuxfd;
    license = with lib.licenses; [ lgpl3 ];
  };
}
