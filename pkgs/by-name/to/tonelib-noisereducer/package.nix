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
  pname = "tonelib-noisereducer";
  version = "2.0";

  src = fetchurl {
    url = "https://tonelib.vip/download/24-12-01/ToneLib-NoiseReducer-amd64.deb";
    hash = "sha256-R+JXoc6waKGPMaghlJ8BkLumDcjC7Oq0jx8tFjAKegE=";
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

    runHook postInstall
  '';

  meta = {
    description = "ToneLib NoiseReducer – two-unit noise reduction rack effect plugin";
    homepage = "https://tonelib.net/tl-noisereducer.html";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ToneLib-NoiseReducer";
  };
}
