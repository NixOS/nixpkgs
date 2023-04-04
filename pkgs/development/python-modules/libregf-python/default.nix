{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libregf-python";
  name = pname;
  version = "20221026";

  meta = with lib; {
    description = "Python bindings module for libregf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libregf/";
    downloadPage = "https://github.com/libyal/libregf/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ofTpfiIERGE6YdM3mut/dl0P72tjiwp5tKBB0MaPZ6Q=";
  };
}
