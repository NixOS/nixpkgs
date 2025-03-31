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
  python3,
  SDL2,
  stdenv,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "the-powder-toy";
  version = "99.3.384";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    tag = "v${version}";
    hash = "sha256-vlswHNkjyxM9sZT+mwiCMfNbdAbhYyx06w+ZLfaPaEQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ] ++ lib.optional stdenv.hostPlatform.isLinux copyDesktopItems;

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
  ] ++ lib.optional stdenv.hostPlatform.isDarwin Cocoa;

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
    description = "Free 2D physics sandbox game";
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
