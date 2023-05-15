{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libregf-python";

  version = "20221026";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ofTpfiIERGE6YdM3mut/dl0P72tjiwp5tKBB0MaPZ6Q=";
  };

  meta = with lib; {
    description = "Python bindings module for libregf";
    downloadPage = "https://github.com/libyal/libregf/releases";
    homepage = "https://github.com/libyal/libregf/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
