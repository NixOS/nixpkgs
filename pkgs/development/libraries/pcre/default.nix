{stdenv, fetchurl, unicodeSupport ? false, cplusplusSupport ? true}:

stdenv.mkDerivation {
  name = "pcre-8.02";

  src = fetchurl {
    url = mirror://sourceforge/pcre/pcre-8.02.tar.bz2;
    sha256 = "1gafmkmkbpdqjbdl85q2z5774gw4gfqjf238icz7gqf3v4v90xd4";
  };

  configureFlags = ''
    ${if unicodeSupport then "--enable-unicode-properties" else ""}
    ${if !cplusplusSupport then "--disable-cpp" else ""}
  '';

  meta = {
    homepage = http://www.pcre.org/;
    description = "A library for Perl Compatible Regular Expressions";
  };
}
