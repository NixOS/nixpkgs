{ fetchurl, stdenv, libiconv }:

stdenv.mkDerivation rec {
  name = "libunistring-0.9.7";

  src = fetchurl {
    url = "mirror://gnu/libunistring/${name}.tar.gz";
    sha256 = "1ra1baz2187kbw9im47g6kqb5mx9plq703mkjxaval8rxv5q3q4w";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./clang.patch stdenv.secure-format-patch ];

  outputs = [ "out" "dev" "info" "doc" ];

  propagatedBuildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;

  configureFlags = [
    "--with-libiconv-prefix=${libiconv}"
  ];

  # XXX: There are test failures on non-GNU systems, see
  # http://lists.gnu.org/archive/html/bug-libunistring/2010-02/msg00004.html .
  doCheck = stdenv ? glibc;

  meta = {
    homepage = http://www.gnu.org/software/libunistring/;

    description = "Unicode string library";

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

    license = stdenv.lib.licenses.lgpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
