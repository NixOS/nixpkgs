{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libfwnt-python";

  version = "20220922";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SCUK5cNpMNdUAj1PSXhqhgnAV8VWfDf4vYHiasmmXaE=";
  };

  meta = with lib; {
    description = "Python bindings module for libfwnt";
    downloadPage = "https://github.com/libyal/libfwnt/releases";
    homepage = "https://github.com/libyal/libfwnt/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
