{ fetchurl, stdenv, nss, openssl, pkgconfig }:


stdenv.mkDerivation rec {
  name = "liboauth-1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/liboauth/${name}.tar.gz";
    sha256 = "12wdwq09nba8dzzcgcpbzmgcjr141ky69pm78s15hyyvw4px71sh";
  };

  buildInputs = [ nss openssl ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    description = "C library implementing the OAuth secure authentication protocol";
    homepage = http://liboauth.sourceforge.net/;
  };

}
