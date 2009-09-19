{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "libiconv-1.13.1";

  src = fetchurl {
    url = "mirror://gnu/libiconv/${name}.tar.gz";
    sha256 = "0jcsjk2g28bq20yh7rvbn8xgq6q42g8dkkac0nfh12b061l638sm";
  };

  meta = {
    description = "GNU libiconv, an iconv(3) implementation";

    longDescription = ''
      Some programs, like mailers and web browsers, must be able to convert
      between a given text encoding and the user's encoding.  Other programs
      internally store strings in Unicode, to facilitate internal processing,
      and need to convert between internal string representation (Unicode)
      and external string representation (a traditional encoding) when they
      are doing I/O.  GNU libiconv is a conversion library for both kinds of
      applications.
    '';

    homepage = http://www.gnu.org/software/libiconv/;
    license = "LGPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];

    # This library is not needed on GNU platforms.
    platforms = [ "i686-cygwin" "i686-darwin" ];
  };
}
