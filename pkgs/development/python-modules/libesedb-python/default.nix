{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libesedb-python";
  name = pname;
  version = "20220806";

  meta = with lib; {
    description = "Python bindings module for libesedb";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libesedb/";
    downloadPage = "https://github.com/libyal/libesedb/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MJ6xvtuhxuf4sKGQ7aHolu8UlEcmN7dzbStFBSrVU+g=";
  };
}
