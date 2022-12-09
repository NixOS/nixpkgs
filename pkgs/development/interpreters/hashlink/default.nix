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
  version = "1.12";

  src = fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = version;
    sha256 = "AiUGhTxz4Pkrks4oE+SAuAQPMuC5T2B6jo3Jd3sNrkQ=";
  };

  patches = [ ./hashlink.patch ];

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
    description = "A virtual machine for Haxe";
    homepage = "https://hashlink.haxe.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ iblech locallycompact logo ];
  };
}
