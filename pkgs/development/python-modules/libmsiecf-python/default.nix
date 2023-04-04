{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libmsiecf-python";
  name = pname;
  version = "20221024";

  meta = with lib; {
    description = "Python bindings module for libmsiecf";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libmsiecf/";
    downloadPage = "https://github.com/libyal/libmsiecf/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8Ch7mVkgUFEFWquOq/oamOTFd63/vQ1QOuxTdVSoiLg=";
  };
}
