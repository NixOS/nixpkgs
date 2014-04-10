{ fetchurl, stdenv, nss, openssl, pkgconfig }:


stdenv.mkDerivation rec {
  name = "liboauth-1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/liboauth/${name}.tar.gz";
    sha256 = "1qs58yzydw20dmzvx22i541w641kwd6ja80s9na1az32n1krh6zv";
  };

  buildInputs = [ nss openssl ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    description = "C library implementing the OAuth secure authentication protocol";
    homepage = http://liboauth.sourceforge.net/;
    repositories.git = https://github.com/x42/liboauth.git;
  };

}
