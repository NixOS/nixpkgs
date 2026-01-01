{
  buildMozillaMach,
  fetchFromGitHub,
  lib,
  nixosTests,
  stdenv,
}:

(buildMozillaMach rec {
  pname = "waterfox";
  version = "140.13.0";
  packageVersion = "6.6.15";
  applicationName = "Waterfox";
  binaryName = "waterfox";
  branding = "waterfox/browser/branding";
  requireSigning = false;
  src = fetchFromGitHub {
    owner = "BrowserWorks";
    repo = "Waterfox";
    tag = packageVersion;
    hash = "sha256-pwEG42CTXjT//xIoESkhB1OD3G1L3Dp//mXjG9a9k5I=";
    fetchSubmodules = true;
    # We can't clone the submodules with SSH.
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
  };

  __structuredAttrs = true;
  strictDeps = true;

  extraPatches = [
    # Some of the icons are missing and cause the build to crash. Removing them fixes the issue.
    ./remove-missing-icons.patch
  ];

  extraPostPatch = ''
    # `buildMozillaMach` will take care of the build.
    rm .mozconfig .mozconfig-*

    # Override the default Firefox version.
    for fn in browser/config/version.txt browser/config/version_display.txt; do
      echo "${packageVersion}" > "$fn"
    done
  '';

  meta = {
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    changelog = "https://github.com/BrowserWorks/waterfox/releases/tag/${src.tag}";
    description = "Privacy-focused Firefox Fork";
    homepage = "https://www.waterfox.com";
    license = lib.licenses.mpl20;
    mainProgram = "waterfox";
    maintainers = with lib.maintainers; [
      aurelivia
      defelo
      ethancedwards8
      hythera
    ];
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    platforms = lib.platforms.unix;
  };
  tests = { inherit (nixosTests) waterfox; };
  updateScript = ./update.sh;
}).override
  {
    crashreporterSupport = false;
  }
