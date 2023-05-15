{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "liblnk-python";

  version = "20230205";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kgLwfYe7MPj5AYmCJMYna+wFMo3V8A62eNVQnVU8J0k=";
  };

  meta = with lib; {
    description = "Python bindings module for liblnk";
    downloadPage = "https://github.com/libyal/liblnk/releases";
    homepage = "https://github.com/libyal/liblnk/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
