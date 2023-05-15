{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libevtx-python";

  version = "20221101";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2ABOow7Dq9W2MS4J221OQ6OX1UqQZ9reseZpu7/qDTc=";
  };

  meta = with lib; {
    description = "Python bindings module for libevtx";
    downloadPage = "https://github.com/libyal/libevtx/releases";
    homepage = "https://github.com/libyal/libevtx/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
