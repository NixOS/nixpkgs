{
  buildMozillaMach,
  callPackage,
  lib,
  nixosTests,
  stdenv,
}:
let
  zen-browser-src = callPackage ./zen-browser.nix { };
in
(buildMozillaMach {
  inherit (zen-browser-src) extraNativeBuildInputs extraPostPatch;
  pname = "zen-browser";
  allowAddonSideload = true;
  applicationName = "Zen";
  binaryName = "zen";
  branding = "browser/branding/release";
  extraPassthru = {
    inherit (zen-browser-src) ffprefs;
    inherit zen-browser-src;
  };
  packageVersion = zen-browser-src.zen-version;
  requireSigning = false;
  src = zen-browser-src.firefox-src;
  version = zen-browser-src.firefox-version;

  meta = {
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    broken = stdenv.buildPlatform.is32bit;
    description = "Firefox fork with a focus on looks and privacy";
    homepage = "https://zen-browser.app";
    license = lib.licenses.mpl20;
    mainProgram = "zen";
    maintainers = with lib.maintainers; [ hythera ];
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    platforms = lib.platforms.unix;
  };
  tests = { inherit (nixosTests) zen-browser; };
  updateScript = ./update.sh;
}).override
  {
    crashreporterSupport = false;
    enableOfficialBranding = false;
  }
