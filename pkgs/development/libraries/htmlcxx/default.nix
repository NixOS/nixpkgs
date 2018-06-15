{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "htmlcxx-${version}";
  version = "0.86";

  src = fetchurl {
    url = "mirror://sourceforge/htmlcxx/htmlcxx/${version}/${name}.tar.gz";
    sha256 = "1hgmyiad3qgbpf2dvv2jygzj6jpz4dl3n8ds4nql68a4l9g2nm07";
  };

  patches = [ ./ptrdiff.patch ];

  meta = with stdenv.lib; {
    homepage = http://htmlcxx.sourceforge.net/;
    description = "A simple non-validating css1 and html parser for C++";
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
