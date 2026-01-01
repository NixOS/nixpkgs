{
  apple-sdk_15,
  buildMozillaMach,
  fetchFromGitHub,
  lib,
  nixosTests,
  nix-update-script,
  stdenv,
}:
buildMozillaMach rec {
  pname = "waterfox";
  version = "6.6.9";
  applicationName = "Waterfox";
  binaryName = "waterfox";
  branding = "waterfox/browser/branding";
  src = fetchFromGitHub {
    owner = "BrowserWorks";
    repo = "Waterfox";
    tag = version;
    hash = "sha256-mrbXjztb4+qUnXEB/WrXN0x6AiBjz7yPqLwTuqeQfUg=";
    fetchSubmodules = true;
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    ''; # We can't clone with SSH here
  };

  extraBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15 # Browser requires sdk 15+ to work on darwin
  ];

  extraConfigureFlags = [
    "--with-app-basename=${applicationName}"
  ];

  extraPatches = [
    ./remove-missing-icons.patch
  ]; # Some of the icons are missing and cause the build to crash. Removing them fixes the issue

  extraPostPatch = ''
    rm .mozconfig .mozcinfig-*
  ''; # buildMozillaMach will take care of the build arguments

  meta = {
    broken = stdenv.buildPlatform.is32bit;
    # since Firefox 60, build on 32-bit platforms fails with "out of memory".
    # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    changelog = "https://github.com/BrowserWorks/waterfox/releases/tag/${version}";
    description = "A privacy-focused Firefox Fork";
    homepage = "https://www.waterfox.com";
    license = lib.licenses.mpl20;
    mainProgram = "waterfox";
    maintainers = with lib.maintainers; [
      aurelivia
      ethancedwards8 # Darwin
      hythera
    ];
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    platforms = lib.platforms.unix;
  };
  tests = { inherit (nixosTests) waterfox; };
  updateScript = nix-update-script { };
}
