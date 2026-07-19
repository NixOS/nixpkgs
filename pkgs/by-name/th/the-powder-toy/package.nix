{
  bzip2,
  copyDesktopItems,
  curl,
  fetchFromGitHub,
  fftwFloat,
  jsoncpp,
  lib,
  libpng,
  libx11,
  lua5_2,
  luajit,
  meson,
  ninja,
  pkg-config,
  python3,
  SDL2,
  stdenv,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "the-powder-toy";
  version = "100.0.399";

  src = fetchFromGitHub {
    owner = "The-Powder-Toy";
    repo = "The-Powder-Toy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1k2GFYQ6Jrs6+BlcKtLqSRClQAa0/YwWF1+9m7q/Nps=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux copyDesktopItems;

  buildInputs = [
    bzip2
    curl
    fftwFloat
    jsoncpp
    libpng
    libx11
    lua5_2
    luajit
    SDL2
    zlib
  ];

  mesonFlags = [ "-Dworkaround_elusive_bzip2=none" ];

  installPhase = ''
    runHook preInstall

    install -Dm 755 powder $out/bin/powder

    mkdir -p $out/share
    mv ../resources $out/share

    runHook postInstall
  '';

  desktopItems = [ "resources/powder.desktop" ];

  meta = {
    description = "Free 2D physics sandbox game";
    homepage = "https://powdertoy.co.uk/";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      siraben
    ];
    mainProgram = "powder";
  };
})
