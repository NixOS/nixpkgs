{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  alsa-lib,
  freetype,
  libglvnd,
  libgbm,
  curl,
  libXcursor,
  libXinerama,
  libXrandr,
  libXrender,
  libjack2,
}:
stdenv.mkDerivation rec {
  pname = "tonelib-metal";
  version = "1.3.0";

  src = fetchurl {
    url = "https://tonelib.vip/download/24-10-24/ToneLib-Metal-amd64.deb";
    hash = "sha256-H19ZUOFI7prQJPo9NWWAHSOwpZ4RIbpRJHfQVjDp/VA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  runtimeDependencies = map lib.getLib [
    curl
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libjack2
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    alsa-lib
    freetype
    libglvnd
    libgbm
  ] ++ runtimeDependencies;

  installPhase = ''
    runHook preInstall

    cp -r usr $out
    substituteInPlace $out/share/applications/ToneLib-Metal.desktop \
      --replace-fail "/usr/" "$out/"

    runHook postInstall
  '';

  meta = {
    description = "ToneLib Metal – Guitar amp simulator targeted at metal players";
    homepage = "https://tonelib.net";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ToneLib-Metal";
  };
}
