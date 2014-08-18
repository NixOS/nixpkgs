{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {

  name = "libgadu-1.11.2";

  src = fetchurl {
    url = http://toxygen.net/libgadu/files/libgadu-1.11.2.tar.gz;
    sha256 = "0kifi9blhbimihqw4kaf6wyqhlx8fpp8nq4s6y280ar9p0il2n3z";
  };

  propagatedBuildInputs = [ zlib ];

  meta = {
    description = "A library to deal with gadu-gadu protocol (most popular polish IM protocol)";
    homepage = http://toxygen.net/libgadu/;
    platforms = stdenv.lib.platforms.linux;
    license = "LGPLv2.1";
  };

}
