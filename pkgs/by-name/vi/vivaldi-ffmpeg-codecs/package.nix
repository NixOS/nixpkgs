{
  fetchurl,
  lib,
  squashfsTools,
  stdenv,
}:

# This derivation roughly follows the update-ffmpeg script that ships with the official Vivaldi
# downloads at https://vivaldi.com/download/

let
  sources = {
    x86_64-linux = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_117.snap";
      hash = "sha256-YEE7oF8NLGDCQ3gpY5z6B+7xDxcOumjOzwUztJUM+/s=";
    };
    aarch64-linux = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_116.snap";
      hash = "sha256-4RmVOQ9emlRyzAGxeiSLwvkGv+7R/mKLVYm5IWXqLpo=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chromium-codecs-ffmpeg-extra";

  version = "2026-05-18";

  src = sources."${stdenv.hostPlatform.system}";

  buildInputs = [ squashfsTools ];

  unpackPhase = ''
    unsquashfs -dest . $src
  '';

  installPhase = ''
    install -vD chromium-ffmpeg-git-${finalAttrs.version}/chromium-ffmpeg/libffmpeg.so $out/lib/libffmpeg.so
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Additional support for proprietary codecs for Vivaldi and other chromium based tools";
    homepage = "https://ffmpeg.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      betaboon
      cawilliamson
      fptje
      sarahec
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
