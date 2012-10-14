{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "unac-1.7.0";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/unac/unac-1.7.0.tar.gz;
    sha256 = "1r54dzgcgrmllps1wzivzwx1dzjxcs7v2swwf7jrlp125154k0jy";
  };

  patches = [ ./multiline-string.patch ];

  buildInputs = [ perl ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "unac is a C library and command that removes accents from a string.";
    longDescription = ''
      unac is a C library and command that removes accents from a string. For
      instance the string été will become ete. It provides a command line interface
      that removes accents from a input flow or a string given in argument (unaccent
      command).
    '';
    homepage = http://savannah.nongnu.org/projects/unac;
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
