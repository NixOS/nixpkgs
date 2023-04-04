{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libevtx-python";
  name = pname;
  version = "20221101";

  meta = with lib; {
    description = "Python bindings module for libevtx";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libevtx/";
    downloadPage = "https://github.com/libyal/libevtx/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2ABOow7Dq9W2MS4J221OQ6OX1UqQZ9reseZpu7/qDTc=";
  };
}
