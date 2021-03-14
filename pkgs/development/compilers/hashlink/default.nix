{ lib, stdenv, fetchFromGitHub, libpng, libjpeg_turbo, libvorbis, SDL2, mesa_glu, mbedtls, openal, libuv }:

stdenv.mkDerivation rec {
  pname = "hashlink";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = version;
    sha256 = "sha256-Mw0AMPK4fdaAdq+BjnFDpo0B9qhTrecD8roLA/JF/a0=";
  };

  buildInputs = [ libpng libjpeg_turbo libvorbis SDL2 mesa_glu mbedtls openal libuv ];

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include
    cp hl $out/bin
    cp libhl.so *.hdll $out/lib
    cp src/hl.h src/hlc.h src/hlc_main.c $out/include
  '';

  meta = with lib; {
    description = "A virtual machine for Haxe";
    homepage = "https://hashlink.haxe.org";
    license = licenses.mit;
    maintainers = [ maintainers.locallycompact ];
    platforms = platforms.linux;
  };
}
