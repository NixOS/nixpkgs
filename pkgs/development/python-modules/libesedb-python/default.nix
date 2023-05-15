{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libesedb-python";

  version = "20220806";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MJ6xvtuhxuf4sKGQ7aHolu8UlEcmN7dzbStFBSrVU+g=";
  };

  meta = with lib; {
    description = "Python bindings module for libesedb";
    downloadPage = "https://github.com/libyal/libesedb/releases";
    homepage = "https://github.com/libyal/libesedb/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
