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
      platformSpecificTag = "linux_x64";
      hash = "sha256-t3JgcMpweWXpoXs45PFbooO/b2XDOWJsCShir3sZutw=";
    };
    aarch64-linux = {
      debArch = "arm64";
      platformSpecificTag = "linux_arm64";
      hash = "sha256-JF+o2kpSwVvueBHT4XiSeSyr1jYaxbfpx4umSCrRgxU=";
    };
  };

  currentPlatform =
    platformMeta.${stdenv.hostPlatform.system}
      or (throw "widevine-cdm isn't supported on ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "widevine-cdm";
  version = "4.10.3112.0";
  googleChromeVersion = "155.0.8059.79";

  src = fetchurl {
    url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${finalAttrs.googleChromeVersion}-1_${currentPlatform.debArch}.deb";
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

    mkdir -p "$out/gmp-widevinecdm/system-installed"
    ln -s "$out/share/google/chrome/WidevineCdm/manifest.json" "$out/gmp-widevinecdm/system-installed/manifest.json"
    ln -s "$out/share/google/chrome/WidevineCdm/_platform_specific/${currentPlatform.platformSpecificTag}/libwidevinecdm.so" "$out/gmp-widevinecdm/system-installed/libwidevinecdm.so"

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
