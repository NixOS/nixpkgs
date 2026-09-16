{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glibc,
}:

let
  platformMeta = {
    x86_64-linux = {
      debArch = "amd64";
      hash = "sha256-TSXkoCjHinrpEGg1UcLyNHksxVlefj40k59Zk0KtpEY=";
    };
    aarch64-linux = {
      debArch = "arm64";
      hash = "sha256-HcBFWH2AjCB6GenrNw9ukS3X5pZpU6+5PIHZnD/jGOM=";
    };
  };

  currentPlatform =
    platformMeta.${stdenv.hostPlatform.system}
      or (throw "widevine-cdm isn't supported on ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "widevine-cdm";
  version = "152.0.7977.82";

  src = fetchurl {
    url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${finalAttrs.version}-1_${currentPlatform.debArch}.deb";
    inherit (currentPlatform) hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    glibc
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack

    ar x $src
    tar -xf data.tar.* \
        --no-same-owner \
        --no-same-permissions \
        --wildcards './opt/google/chrome/WidevineCdm*'

    runHook postUnpack
  '';

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/google/chrome"
    cp -r opt/google/chrome/WidevineCdm "$out/share/google/chrome/"

    find "$out" -type f -name "*.so" -exec chmod +x {} +

    runHook postInstall
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Widevine Content Decryption Module";
    homepage = "https://www.widevine.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.attrNames platformMeta;
    maintainers = with lib.maintainers; [
      jlamur
      bearfm
    ];
  };
})
