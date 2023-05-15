{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libphdi-python";

  version = "20221025";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5FiLLvGv4470DdcKbWLEWpxAfn3aHwBmZuU98mAviGo=";
  };

  meta = with lib; {
    description = "Python bindings module for libphdi";
    downloadPage = "https://github.com/libyal/libphdi/releases";
    homepage = "https://github.com/libyal/libphdi/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
