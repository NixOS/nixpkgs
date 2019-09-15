{ lib, buildPythonPackage, fetchPypi
, appdirs, beautifulsoup4, colorama, fasteners, future, intelhex
, junit-xml , lockfile, prettytable, pyserial, requests, six
}:

buildPythonPackage rec {
  pname = "mbed-os-tools";
  version = "0.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fcgw0mlwapj0sy4dd7lx2z2a6ck2ambx6mymwi0c4sa48n4d8x6";
  };

  propagatedBuildInputs = [
    appdirs
    beautifulsoup4
    colorama
    fasteners
    future
    intelhex
    junit-xml
    lockfile
    prettytable
    pyserial
    requests
    six
  ];

  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/ARMmbed/mbed-os-tools;
    description = "List processing tools and functional utilities";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
