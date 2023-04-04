{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libsigscan-python";
  name = pname;
  version = "20230109";

  meta = with lib; {
    description = "Python bindings module for libsigscan";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libsigscan/";
    downloadPage = "https://github.com/libyal/libsigscan/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-T6Da1vG5gl+LGQmfuAP7wjnMpBCNo5hkA8bzmGvx/2M=";
  };
}
