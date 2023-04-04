{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "liblnk-python";
  name = pname;
  version = "20230205";

  meta = with lib; {
    description = "Python bindings module for liblnk";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/liblnk/";
    downloadPage = "https://github.com/libyal/liblnk/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kgLwfYe7MPj5AYmCJMYna+wFMo3V8A62eNVQnVU8J0k=";
  };
}
