{ lib
, buildPythonPackage
, fetchsubmodule
}:

buildPythonPackage rec {
  pname = "linuxfd";
  version = "1.4.4";

  name = "${pname}-${version}";

  src = fetchsubmodule "development/python-modules/linuxfd";

  # no tests
  doCheck = false;

  meta = {
    description = "Python bindings for the Linux eventfd/signalfd/timerfd/inotify syscalls";
    homepage = https://github.com/FrankAbelbeck/linuxfd;
    license = with lib.licenses; [ lgpl3 ];
  };
}
