# There are two official Telegram desktop apps:
#
# - Telegram Desktop ("tdesktop"): C++/Qt, GPL-3.0, targets Windows, Linux,
#   and macOS. Website: desktop.telegram.org. GitHub:
#   telegramdesktop/tdesktop. Packaged as `telegram-desktop`, built from
#   source.
# - Telegram for macOS ("TelegramSwift"): Swift, GPL-2.0, targets macOS
#   only. Website: macos.telegram.org. GitHub: overtake/TelegramSwift.
#   Packaged here as `telegram-for-mac`, as a prebuilt binary.
#
# This package is the latter. It repackages the official binary from
# osx.telegram.org without any modification. Three constraints shape it:
#
# 1. Building from source is not possible in nixpkgs. It requires the full
#    Xcode, which nixpkgs cannot ship. Upstream tags no releases and pushes
#    the source with a delay of a year or more. Forks must also register
#    their own Telegram API credentials.
# 2. The Sparkle auto-updater cannot be disabled: patching Info.plist or
#    re-signing breaks the signature and its entitlements. In-app updates
#    therefore fail against the read-only store. We accept this, like other
#    prebuilt app bundles (see daisydisk and monodraw).
# 3. The license is unfree although the GitHub source is GPLv2: binaries
#    ship ahead of the published source, so the source of a given binary is
#    not actually available.
{
  lib,
  stdenvNoCC,
  fetchzip,
  writeShellApplication,
  cacert,
  curl,
  gawk,
  xmlstarlet,
  common-updater-scripts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "telegram-for-mac";
  version = "12.10.282985";

  src = fetchzip {
    url = "https://osx.telegram.org/updates/Telegram-${finalAttrs.version}.app.zip";
    hash = "sha256-aknRqjc9JTN9E5dyhteWj5cT3NVwTdta+9+pGiHewKA=";
    stripRoot = false;
  };

  __structuredAttrs = true;
  strictDeps = true;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Telegram.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "telegram-for-mac-update-script";
    runtimeInputs = [
      cacert
      curl
      gawk
      xmlstarlet
      common-updater-scripts
    ];
    text = ''
      # The feed's pubDate values are malformed, so take the entry with the
      # highest build number instead of the newest entry.
      version=$(
        curl -sf https://osx.telegram.org/updates/versions.xml \
          | xmlstarlet sel -t -m '//item/enclosure' \
              -v '@sparkle:version' -o ' ' -v '@sparkle:shortVersionString' -n \
          | awk '$1 > build { build = $1; short = $2 } END { print short "." build }'
      )
      update-source-version ${finalAttrs.pname} "$version"
    '';
  });

  meta = {
    description = "Telegram for macOS";
    longDescription = ''
      Official prebuilt binary of Telegram for macOS (TelegramSwift).
    '';
    homepage = "https://macos.telegram.org/";
    # Although the GitHub repository is GPL-2.0, no new source code has been
    # released since July 2025 (as of September 2026), so the software is
    # effectively unfree.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ larry0x ];
    platforms = lib.platforms.darwin;
  };
})
