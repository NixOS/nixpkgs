{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libvhdi-python";
  name = pname;
  version = "20221124";

  meta = with lib; {
    description = "Python bindings module for libvhdi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libvhdi/";
    downloadPage = "https://github.com/libyal/libvhdi/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IxDeXPBD8axii/2NF5ugG88GbzE64G56W1BLKgjdWQM=";
  };
}
