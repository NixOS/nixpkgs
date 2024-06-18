{ stdenv
, lib
, fetchFromGitHub
, libGL
, libGLU
, libpng
, libjpeg_turbo
, libuv
, libvorbis
, mbedtls_2
, openal
, pcre
, SDL2
, sqlite
, getconf
}:

stdenv.mkDerivation rec {
  pname = "hashlink";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = version;
    sha256 = "lpHW0JWxbLtOBns3By56ZBn47CZsDzwOFBuW9MlERrE=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [
    libGL
    libGLU
    libjpeg_turbo
    libpng
    libuv
    libvorbis
    mbedtls_2
    openal
    pcre
    SDL2
    sqlite
  ];

  nativeBuildInputs = [ getconf ];

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libhl.dylib $out/lib/libhl.dylib $out/bin/hl
  '';

  meta = with lib; {
    description = "Virtual machine for Haxe";
    mainProgram = "hl";
    homepage = "https://hashlink.haxe.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ iblech locallycompact logo ];
  };
}
