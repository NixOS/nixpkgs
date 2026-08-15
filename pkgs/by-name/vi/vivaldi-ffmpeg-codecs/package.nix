{
  fetchurl,
  lib,
  squashfsTools,
  stdenv,
}:

# This derivation roughly follows the update-ffmpeg script that ships with the official Vivaldi
# downloads at https://vivaldi.com/download/

let
  # IMPORTANT: Use the maintainer's update script to update these. The build number suffixes are unique to
  # each platform and must be updated together. The actual version number requires unpacking the snap.
  sources = {
    x86_64-linux = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_118.snap";
      hash = "sha256-NYSbCLPCr2oxrVUokEC8g1BiZfIcQLaNKeMBkMNCsaI=";
    };
    aarch64-linux = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_119.snap";
      hash = "sha256-ehepMMrt0GO9zoi40fFbO4sEQSgRJjbQax6efQnmF60=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chromium-codecs-ffmpeg-extra";

  version = "0-unstable-2026-05-18"; # Do not update by hand, use the update script

  src = sources."${stdenv.hostPlatform.system}";

  buildInputs = [ squashfsTools ];

  unpackPhase = ''
    unsquashfs -dest . $src
  '';

  installPhase = ''
    install -vD chromium-ffmpeg-git-${lib.removePrefix "0-unstable-" finalAttrs.version}/chromium-ffmpeg/libffmpeg.so $out/lib/libffmpeg.so
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
      brw
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
