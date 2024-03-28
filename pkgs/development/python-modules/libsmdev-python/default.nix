{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libsmdev-python";

  version = "20221028";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7UYGsw/udeXdQozYSiqPUPEyGQhYPoC3yQlrmmYJUb0=";
  };

  meta = with lib; {
    description = "Python bindings module for libsmdev";
    downloadPage = "https://github.com/libyal/libsmdev/releases";
    homepage = "https://github.com/libyal/libsmdev/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
