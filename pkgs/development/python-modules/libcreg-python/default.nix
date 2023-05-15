{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "libcreg-python";

  version = "20221022";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N/E0u3WyXe+zRT0NAr0OoeqlNiQQcZsI6hTgD+JhsAo=";
  };

  meta = with lib; {
    description = "Python bindings module for libcreg";
    downloadPage = "https://github.com/libyal/libcreg/releases";
    homepage = "https://github.com/libyal/libcreg/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };
}
