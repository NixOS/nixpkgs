{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libscca-python";
  name = pname;
  version = "20221027";

  meta = with lib; {
    description = "Python bindings module for libscca";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libscca/";
    downloadPage = "https://github.com/libyal/libscca/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vRM70TjuAKJ9Eehi/jtsnJaIVdMh+kA/VRDgcelXgrI=";
  };
}
