{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "filebytes";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h97i6h525hg401dvvaa5krxi184qpvldbdn0izmirvr9pvh4hkn";
  };

  meta = with stdenv.lib; {
    homepage = "https://scoding.de/filebytes-introduction";
    license = licenses.gpl2;
    description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
    maintainers = with maintainers; [ bennofs ];
  };

}
