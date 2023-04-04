{ buildPythonPackage, fetchPypi, lib, zlib }:
buildPythonPackage rec {
  pname = "libfsapfs-python";
  name = pname;
  version = "20221102";

  meta = with lib; {
    description = "Python bindings module for libfsapfs";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfsapfs/";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v6lD23VJXONC59QC2kkZ2KdThUSXuv7qBdgFXWPu3Wc=";
  };
}
