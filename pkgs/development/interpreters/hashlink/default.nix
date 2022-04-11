{ stdenv
, lib
, fetchFromGitHub
, libpng
, libjpeg_turbo
, libvorbis
, openal
, SDL2
, mbedtls
, libuv
, libGLU
}:

stdenv.mkDerivation rec {
  pname = "hashlink";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = version;
    sha256 = "Mw0AMPK4fdaAdq+BjnFDpo0B9qhTrecD8roLA/JF/a0=";
  };

  buildInputs = [ libpng libjpeg_turbo libvorbis openal SDL2 mbedtls libuv libGLU ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A virtual machine for Haxe";
    homepage = "https://hashlink.haxe.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ iblech ];
  };
}
