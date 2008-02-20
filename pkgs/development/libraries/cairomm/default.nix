args: with args;

stdenv.mkDerivation rec {
  name = "cairomm-1.4.6";

  src = fetchurl {
    url = "http://cairographics.org/releases/${name}.tar.gz";
    sha256 = "1zd5pq5jd507w1v994awpsl7m26g4dfl0rwgrxig2823hl3rqmrp";
  };

  buildInputs = [pkgconfig];
  propagatedBuildInputs = [cairo x11 fontconfig freetype];

  configureFlags = "--enable-shared --disable-static";
}
