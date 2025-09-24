{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "uni2ascii";
  version = "4.20";

  src = fetchurl {
    url = "https://billposer.org/Software/Downloads/uni2ascii-${version}.tar.gz";
    hash = "sha256-7tjYOpwdLb0NfKTFJRmYg9cxfWiLQhtXjQmKJ7b/cFY=";
  };

  patches = [
    (fetchurl {
      url = "https://github.com/Homebrew/formula-patches/raw/bb92449ad6b3878b4d6f472237152df28080df86/uni2ascii/uni2ascii-4.20.patch";
      hash = "sha256-JQpSntoTbQ7fnmO5Km/pX071360/lOb9jYdxOK2oV/g=";
    })
  ];

  meta = {
    license = lib.licenses.gpl3;
    homepage = "http://billposer.org/Software/uni2ascii.html";
    description = "Converts between UTF-8 and many 7-bit ASCII equivalents and back";

    longDescription = ''
      This package provides conversion in both directions between UTF-8
      Unicode and more than thirty 7-bit ASCII equivalents, including
      RFC 2396 URI format and RFC 2045 Quoted Printable format, the
      representations used in HTML, SGML, XML, OOXML, the Unicode
      standard, Rich Text Format, POSIX portable charmaps, POSIX locale
      specifications, and Apache log files, and the escapes used for
      including Unicode in Ada, C, Common Lisp, Java, Pascal, Perl,
      Postscript, Python, Scheme, and Tcl.

      Such ASCII equivalents are useful when including Unicode text in
      program source, when debugging, and when entering text into web
      programs that can handle the Unicode character set but are not
      8-bit safe. For example, MovableType, the blog software, truncates
      posts as soon as it encounters a byte with the high bit
      set. However, if Unicode is entered in the form of HTML numeric
      character entities, Movable Type will not garble the post.

      It also provides ways of converting non-ASCII characters to
      similar ASCII characters, e.g. by stripping diacritics.
    '';
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
