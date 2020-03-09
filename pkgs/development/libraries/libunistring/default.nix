{ fetchurl, stdenv, libiconv }:

stdenv.mkDerivation rec {
  pname = "libunistring";
  version = "0.9.10";

  src = fetchurl {
    url = "mirror://gnu/libunistring/${pname}-${version}.tar.gz";
    sha256 = "02v17za10mxnj095x4pvm80jxyqwk93kailfc2j8xa1r6crmnbm8";
  };

  outputs = [ "out" "dev" "info" "doc" ];

  propagatedBuildInputs = stdenv.lib.optional (!stdenv.isLinux) libiconv;

  configureFlags = [
    "--with-libiconv-prefix=${libiconv}"
  ];

  doCheck = false;

  /* This seems to cause several random failures like these, which I assume
     is because of bad or missing target dependencies in their build system:

        ./unistdio/test-u16-vasnprintf2.sh: line 16: ./test-u16-vasnprintf1: No such file or directory
        FAIL unistdio/test-u16-vasnprintf2.sh (exit status: 1)

        FAIL: unistdio/test-u16-vasnprintf3.sh
        ======================================

        ./unistdio/test-u16-vasnprintf3.sh: line 16: ./test-u16-vasnprintf1: No such file or directory
        FAIL unistdio/test-u16-vasnprintf3.sh (exit status: 1)
  */
  enableParallelBuilding = false;

  meta = {
    homepage = https://www.gnu.org/software/libunistring/;

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
