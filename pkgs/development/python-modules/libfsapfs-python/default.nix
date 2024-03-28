{ buildPythonPackage, fetchPypi, lib, zlib }:

buildPythonPackage rec {
  pname = "libfsapfs-python";

  version = "20221102";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v6lD23VJXONC59QC2kkZ2KdThUSXuv7qBdgFXWPu3Wc=";
  };

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Python bindings module for libfsapfs";
    downloadPage = "https://github.com/libyal/libfsapfs/releases";
    homepage = "https://github.com/libyal/libfsapfs/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
