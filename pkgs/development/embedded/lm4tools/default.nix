{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libusb1
, darwin
, testers
, buildPackages
# As per the README, `lmicdiusb` is not supported on Windows since it needs
# `poll`:
# https://github.com/utzig/lm4tools/blob/61a7d17b85e9b4b040fdaf84e02599d186f8b585/README.md#L15
, buildLmicdiusb ? !stdenv.hostPlatform.isWindows
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lm4tools";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "utzig";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "ZjuCH/XjQEgg6KHAvb95/BkAy+C2OdbtBb/i6K30+uo=";
  };

  patches = [
    # We don't want the Makefile to assume `libusb` lives in /usr/local/lib.
    ./macOS-use-pkg-config.patch
    # When cross compiling `pkg-config` may have a prefix; we want to get its
    # name/path from `$PKG_CONFIG`.
    ./use-pkg-config-env-var.patch
    # Build with `-O2`:
    ./use-release-config-for-build.patch
    # Have the `Makefile`s pass `pkg-config` the right flags when doing a
    # static build.
    #
    # See the comment on `configurePhase` below.
    ./pkg-config-static-build-support.patch
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    # The minGW toolchain appends a `.exe` if it's not present which confuses
    # `install`.
    ./windows-file-ext.patch
  ] ++ lib.optionals (!buildLmicdiusb) [
    ./disable-lmicdiusb-build.patch
  ];

  # We want to communicate to the `Makefile`s whether or not we are doing a
  # static build so that it can pass `--static` to `pkg-config` if we are.
  # If the `Makefile` does not do this, it will not include "private"
  # dependencies from `libusb1` (some macOS frameworks) and the build will
  # fail.
  #
  # There doesn't seem to be a canonical way to tell if the stdenv is
  # configured to make static binaries. The `makeStatic` stdenv adapters,
  # for example, do not set `stdenv.hostPlatform.isStatic` and add different
  # flags for macOS/Linux/etc.
  # See: https://github.com/NixOS/nixpkgs/blob/0c4d65b21efd3ae2fcdec54492cbaa6542352eb9/pkgs/stdenv/adapters.nix#L56-L135
  #
  # So, we look for the `--enable-static` configure flag as an indicator
  # that we're linking statically (even though the `makeStaticDarwin` adapter
  # in isolation does *not* add this configure flag):
  configurePhase = ''
    if [[ "$configureFlags" =~ "--enable-static" ]]; then
      makeFlagsArray+=(STATIC_BUILD=1)
    fi
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      AppKit Carbon IOKit
    ]);

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # `lmicdiusb` has no help text so we don't check that it can run.
  doCheck = true;
  passthru.tests = let
    inherit (stdenv) hostPlatform;
    emulatorAvailable = hostPlatform.emulatorAvailable buildPackages;
    emulator = hostPlatform.emulator buildPackages;
    binary = lib.getExe finalAttrs.finalPackage;
    extension = hostPlatform.extensions.executable;
    # Wine needs `$HOME` to be writable.
    prelude = lib.optionalString hostPlatform.isWindows "HOME=$(realpath .) ";
  in lib.optionalAttrs emulatorAvailable {
    lm4flash = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = prelude + "${emulator} ${binary}${extension} -V";
    };
  };

  meta = with lib; rec {
    description  = "Tools for TI Stellaris boards";
    longDescription = ''
      Tools to enable multi-platform development on the TI Stellaris
      Launchpad boards (lm4f) and TI Tiva C boards (tm4c).

      Includes `lm4flash` and `lmicdiusb`.
    '';
    homepage     = "https://github.com/utzig/lm4tools";
    downloadPage = "${homepage}/releases/tag/v${finalAttrs.version}";
    changelog    = downloadPage;
    license      = with licenses; [ gpl2Plus bsd3 ];
    maintainers  = with lib.maintainers; [ rrbutani ];
    mainProgram  = "lm4flash";
    platforms    = with lib.platforms; unix ++ windows;
    badPlatforms = with lib.systems.inspect; [
      # `libusb1` doesn't appear to produce DLLs; we get runtime errors when
      # not linking statically.
      { isStatic = false; parsed = patterns.isWindows; }
    ];
  };
})
