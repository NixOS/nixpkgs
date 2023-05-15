{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libmsiecf-python";

  version = "20221024";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8Ch7mVkgUFEFWquOq/oamOTFd63/vQ1QOuxTdVSoiLg=";
  };

  meta = with lib; {
    description = "Python bindings module for libmsiecf";
    downloadPage = "https://github.com/libyal/libmsiecf/releases";
    homepage = "https://github.com/libyal/libmsiecf/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
