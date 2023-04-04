{ buildPythonPackage, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "libcreg-python";
  name = pname;
  version = "20221022";

  meta = with lib; {
    description = "Python bindings module for libcreg";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libcreg/";
    downloadPage = "https://github.com/libyal/libcreg/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N/E0u3WyXe+zRT0NAr0OoeqlNiQQcZsI6hTgD+JhsAo=";
  };
}
