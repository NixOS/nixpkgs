{
  bzip2,
  Cocoa,
  copyDesktopItems,
  curl,
  fetchFromGitHub,
  fftwFloat,
  jsoncpp,
  lib,
  libpng,
  lua,
  luajit,
  meson,
  ninja,
  pkg-config,
  SDL2,
  stdenv,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "98.2.365";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    rev = "refs/tags/v${version}";
    hash = "sha256-S2aUa25EnUfX6ShW6D+wHrsTLxTcCFcZ/uLE9EWGu4Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ] ++ lib.optional stdenv.isLinux copyDesktopItems;

  buildInputs = [
    bzip2
    curl
    fftwFloat
    jsoncpp
    libpng
    lua
    luajit
    SDL2
    zlib
  ] ++ lib.optional stdenv.isDarwin Cocoa;

  mesonFlags = [ "-Dworkaround_elusive_bzip2=false" ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 powder $out/bin/powder

    mkdir -p $out/share
    mv ../resources $out/share

    runHook postInstall
  '';

  desktopItems = [ "resources/powder.desktop" ];

  meta = with lib; {
    description = "A free 2D physics sandbox game";
    homepage = "https://powdertoy.co.uk/";
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      abbradar
      siraben
    ];
    mainProgram = "powder";
  };
}
