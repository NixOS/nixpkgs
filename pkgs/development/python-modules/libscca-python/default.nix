{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libscca-python";

  version = "20221027";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vRM70TjuAKJ9Eehi/jtsnJaIVdMh+kA/VRDgcelXgrI=";
  };

  meta = with lib; {
    description = "Python bindings module for libscca";
    downloadPage = "https://github.com/libyal/libscca/releases";
    homepage = "https://github.com/libyal/libscca/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
