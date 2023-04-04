{ buildPythonPackage, fetchPypi, lib, zlib }:
buildPythonPackage rec {
  pname = "libmodi-python";
  name = pname;
  version = "20221023";

  meta = with lib; {
    description = "Python bindings module for libmodi";
    platforms = platforms.all;
    homepage = "https://github.com/libyal/libmodi/";
    downloadPage = "https://github.com/libyal/libmodi/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.lgpl3Plus;
  };

  buildInputs = [ zlib ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Rlqj+f8NijKi30X/r3/6wcyYl301CH91njC86vF+3co=";
  };
}
