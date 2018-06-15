{ stdenv, fetchurl, xercesc }:
let
    major = "1.9";
    minor = "0";
in
with stdenv; with lib;
mkDerivation rec {
  name = "libcutl-${major}.${minor}";

  meta = {
    description = "A collection of generic and independent components such as meta-programming tests, smart pointers, containers, compiler building blocks" ;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };

  src = fetchurl {
    url = "http://codesynthesis.com/download/libcutl/1.9/${name}.tar.bz2";
    sha1 = "0e8d255145afbc339a3284ef85a43f4baf3fec43";
  };

  buildInputs = [ xercesc ];
}
