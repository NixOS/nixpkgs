{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libvhdi-python";

  version = "20221124";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IxDeXPBD8axii/2NF5ugG88GbzE64G56W1BLKgjdWQM=";
  };

  meta = with lib; {
    description = "Python bindings module for libvhdi";
    downloadPage = "https://github.com/libyal/libvhdi/releases";
    homepage = "https://github.com/libyal/libvhdi/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
