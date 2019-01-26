{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "libargon2-${version}";
  version = "20171227";

  src = fetchFromGitHub {
    owner = "P-H-C";
    repo = "phc-winner-argon2";
    rev = "${version}";
    sha256 = "0sc9zca1anqk41017vjpas4kxi4cbn0zvicv8vj8p2sb2gy94bh8";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pkgconfig
    substitute libargon2.pc $out/lib/pkgconfig/libargon2.pc \
      --replace @UPSTREAM_VER@ "${version}"                 \
      --replace @HOST_MULTIARCH@ ""                         \
      --replace 'prefix=/usr' "prefix=$out"

    make install PREFIX=$out
    ln -s $out/lib/libargon2.so $out/lib/libargon2.so.0
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A key derivation function that was selected as the winner of the Password Hashing Competition in July 2015";
    longDescription = ''
      A password-hashing function created by by Alex Biryukov, Daniel Dinu, and
      Dmitry Khovratovich. Argon2 was declared the winner of the Password
      Hashing Competition (PHC). There were 24 submissions and 9 finalists.
      Catena, Lyra2, Makwa and yescrypt were given special recognition. The PHC
      recommends using Argon2 rather than legacy algorithms.
    '';
    homepage = https://www.argon2.com/;
    license = with licenses; [ asl20 cc0 ];
    maintainers = with maintainers; [ taeer olynch ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
