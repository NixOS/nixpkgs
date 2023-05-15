{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libsmraw-python";

  version = "20221028";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g9Rfwie7+Q1aUmWnhc0ysscfh3ZCXpV0g0Gv1AM4cek=";
  };

  meta = with lib; {
    description = "Python bindings module for libsmraw";
    downloadPage = "https://github.com/libyal/libsmraw/releases";
    homepage = "https://github.com/libyal/libsmraw/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
