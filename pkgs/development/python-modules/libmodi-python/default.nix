{ buildPythonPackage, fetchPypi, lib, zlib }:

buildPythonPackage rec {
  pname = "libmodi-python";

  version = "20221023";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Rlqj+f8NijKi30X/r3/6wcyYl301CH91njC86vF+3co=";
  };

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Python bindings module for libmodi";
    downloadPage = "https://github.com/libyal/libmodi/releases";
    homepage = "https://github.com/libyal/libmodi/";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
    platforms = platforms.unix;
  };

}
