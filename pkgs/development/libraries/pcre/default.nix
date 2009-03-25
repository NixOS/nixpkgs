{stdenv, fetchurl, unicodeSupport ? false, cplusplusSupport ? true}:

stdenv.mkDerivation {
  name = "pcre-7.8";
  
  src = fetchurl {
    url = mirror://sourceforge/pcre/pcre-7.8.tar.bz2;
    sha256 = "1zsqk352mx2zklf9bgpg9d88ckfdssbbbiyslhrycfckw8m3qpvr";
  };
  
  configureFlags = ''
    ${if unicodeSupport then "--enable-unicode-properties --enable-shared --disable-static" else ""}
    ${if !cplusplusSupport then "--disable-cpp" else ""}
  '';

  meta = {
    homepage = http://www.pcre.org/;
    description = "A library for Perl Compatible Regular Expressions";
  };
}
