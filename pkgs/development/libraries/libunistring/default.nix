{ fetchurl, stdenv, libiconv }:

stdenv.mkDerivation (rec {
  name = "libunistring-0.9.3";

  src = fetchurl {
    url = "mirror://gnu/libunistring/${name}.tar.gz";
    sha256 = "18q620269xzpw39dwvr9zpilnl2dkw5z5kz3mxaadnpv4k3kw3b1";
  };

  propagatedBuildInputs =
    stdenv.lib.optional (! (stdenv ? glibc)) libiconv;

  # XXX: There are test failures on non-GNU systems, see
  # http://lists.gnu.org/archive/html/bug-libunistring/2010-02/msg00004.html .
  doCheck = (stdenv ? glibc);

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

//

# On Cygwin Libtool is unable to find `libiconv.dll' if there's no explicit
# `-L/path/to/libiconv' argument on the linker's command line; and since it
# can't find the dll, it will only create a static library.
(if (stdenv ? glibc)
 then {}
 else { configureFlags = "--with-libiconv-prefix=${libiconv}"; }))
