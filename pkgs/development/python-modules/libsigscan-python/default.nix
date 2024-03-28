{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libsigscan-python";

  version = "20230109";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T6Da1vG5gl+LGQmfuAP7wjnMpBCNo5hkA8bzmGvx/2M=";
  };

  meta = with lib; {
    description = "Python bindings module for libsigscan";
    downloadPage = "https://github.com/libyal/libsigscan/releases";
    homepage = "https://github.com/libyal/libsigscan/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
