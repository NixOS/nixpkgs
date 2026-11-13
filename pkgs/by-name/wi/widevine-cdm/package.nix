{
  lib,
  binutils-unwrapped,
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
      hash = "sha256-1Zh+x0+udCz2rJybs7wDmfyCyDEnwj3790UC8RlK0T0=";
    };
    aarch64-linux = {
      debArch = "arm64";
      platformSpecificTag = "linux_arm64";
      hash = "sha256-cS08UGOG1Z3w60lfVw0dhwjMpeI8JnUuEaOHsIBkvBc=";
    };
  };

  currentPlatform =
    platformMeta.${stdenv.hostPlatform.system}
      or (throw "widevine-cdm isn't supported on ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "widevine-cdm";
  version = "4.10.3112.0";
  googleChromeVersion = "156.0.8078.47";

  src = fetchurl {
    url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${finalAttrs.googleChromeVersion}-1_${currentPlatform.debArch}.deb";
    inherit (currentPlatform) hash;

    downloadToTemp = true;
    recursiveHash = true;

    nativeBuildInputs = [ binutils-unwrapped ];

    postFetch = ''
      unpackDir="$(mktemp -d)"
      cd "$unpackDir"
      ar x "$downloadedFile"

      tar xf data.tar.* \
        --no-same-owner \
        --no-same-permissions \
        --wildcards './opt/google/chrome/WidevineCdm*'

      mv opt/google/chrome/WidevineCdm "$out"
    '';
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    glibc
    stdenv.cc.cc.lib
  ];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/google/chrome/WidevineCdm"
    cp -r "$src/." "$out/share/google/chrome/WidevineCdm/"

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
