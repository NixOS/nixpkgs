{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libfwsi-python";

  version = "20230114";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ReYmz0jfoTfkWwjqSaPhzp5x7RE5jTlInGLi324wCQc=";
  };

  meta = with lib; {
    description = "Python bindings module for libfwsi";
    downloadPage = "https://github.com/libyal/libfwsi/releases";
    homepage = "https://github.com/libyal/libfwsi/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
