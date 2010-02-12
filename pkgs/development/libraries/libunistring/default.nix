{ fetchurl, stdenv, libiconv }:

stdenv.mkDerivation rec {
  name = "libunistring-0.9.1.1";

  src = fetchurl {
    url = "mirror://gnu/libunistring/${name}.tar.gz";
    sha256 = "02qrsncjn7r350p1wgggkg14gbw2r4g4a7awvrggfriqs6nl5qf5";
  };

  propagatedBuildInputs =
    stdenv.lib.optional (stdenv.system == "i686-cygwin"
                         || stdenv.system == "i686-darwin")
                        libiconv;

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/libunistring/;

    description = "GNU Libunistring, a Unicode string library";

    longDescription = ''
      This library provides functions for manipulating Unicode strings
      and for manipulating C strings according to the Unicode
      standard.

      GNU libunistring is for you if your application involves
      non-trivial text processing, such as upper/lower case
      conversions, line breaking, operations on words, or more
      advanced analysis of text.  Text provided by the user can, in
      general, contain characters of all kinds of scripts.  The text
      processing functions provided by this library handle all scripts
      and all languages.

      libunistring is for you if your application already uses the ISO
      C / POSIX <ctype.h>, <wctype.h> functions and the text it
      operates on is provided by the user and can be in any language.

      libunistring is also for you if your application uses Unicode
      strings as internal in-memory representation.
    '';

    license = "LGPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
