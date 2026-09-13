{
  buildMozillaMach,
  fetchFromGitHub,
  lib,
  nixosTests,
  stdenv,
}:

(buildMozillaMach rec {
  pname = "waterfox";
  version = "153.3.0";
  packageVersion = "6.7.3";
  applicationName = "Waterfox";
  binaryName = "waterfox";
  branding = "waterfox/browser/branding";
  src = fetchFromGitHub {
    owner = "BrowserWorks";
    repo = "Waterfox";
    tag = packageVersion;
    hash = "sha256-KTvmDHes0dOCJyRi5kZRj7UsyoLFBVJQSjzb5yxQFTA=";
    leaveDotGit = true;
    fetchSubmodules = true;
    # We can't clone the submodules with SSH.
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git_head
      rm -rf $out/.git
    '';
  };

  extraPatches = [
    # Some of the icons are missing and cause the build to crash. Removing them fixes the issue.
    ./remove-missing-icons.patch

    # conflicts with the distribution id set by buildMozillaMach
    ./remove-implied-distribution-id.patch
  ];

  extraPostPatch = ''
    # `buildMozillaMach` will take care of the build.
    rm .mozconfig .mozconfig-*

    # Override the default Firefox version.
    for fn in browser/config/version.txt browser/config/version_display.txt; do
      echo "${packageVersion}" > "$fn"
    done

    export MOZ_SOURCE_REPO=${lib.removeSuffix ".git" src.url}
    export MOZ_SOURCE_CHANGESET=$(<$src/.git_head)
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
    enableAddonSigning = false;
    enableAddonSideload = true;
    enableCrashReporter = false;
  }
