{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "crypt_blowfish";
  version = "1.3";

  src = fetchurl {
    url = "https://www.openwall.com/crypt/crypt_blowfish-${version}.tar.gz";
    hash = "sha256:1zbjip7aiim33r4022qh6r4nd9850fxfky5phbcfhvwrlvy03yl3";
  };

  installPhase = ''
    mkdir -p $out/lib
    ar cr $out/lib/libcrypt_blowfish.a *.o

    mkdir -p $out/include
    cp *.h $out/include
  '';

  meta = with lib; {
    description = "Implementation of bcrypt, provided via the crypt(3) and a reentrant interface";
    homepage = "https://www.openwall.com/crypt/";
    license = lib.licenses.publicDomain; # There is also a fallback license available.
    platforms = platforms.unix;
    maintainers = [ maintainers.kevincox ];
  };
}
