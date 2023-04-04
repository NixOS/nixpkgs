{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libfwnt-python";
  name = pname;
  version = "20220922";

  meta = with lib; {
    description = "Python bindings module for libfwnt";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libfwnt/";
    downloadPage = "https://github.com/libyal/libfwnt/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SCUK5cNpMNdUAj1PSXhqhgnAV8VWfDf4vYHiasmmXaE=";
  };
}
