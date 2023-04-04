{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libphdi-python";
  name = pname;
  version = "20221025";

  meta = with lib; {
    description = "Python bindings module for libphdi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libphdi/";
    downloadPage = "https://github.com/libyal/libphdi/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5FiLLvGv4470DdcKbWLEWpxAfn3aHwBmZuU98mAviGo=";
  };
}
