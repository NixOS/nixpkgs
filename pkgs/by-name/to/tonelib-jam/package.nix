{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  freetype,
  libglvnd,
  curl,
  libXcursor,
  libXinerama,
  libXrandr,
  libXrender,
  libjack2,
}:

stdenv.mkDerivation rec {
  pname = "tonelib-jam";
  version = "4.8.7";

  src = fetchurl {
    url = "https://tonelib.vip/download/24-10-24/ToneLib-Jam-amd64.deb";
    hash = "sha256-qBCEaV9uw6HHJYK+8AK+JYQK375cY0Ae3gxiQ0+sAg4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    freetype
    libglvnd
  ]
  ++ runtimeDependencies;

  runtimeDependencies = map lib.getLib [
    curl
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libjack2
  ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out
    substituteInPlace $out/share/applications/ToneLib-Jam.desktop \
      --replace-fail "/usr/" "$out/"

    runHook postInstall
  '';

  meta = {
    description = "ToneLib Jam – the learning and practice software for guitar players";
    homepage = "https://tonelib.net/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ToneLib-Jam";
  };
}
