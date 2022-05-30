{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libusb1
, darwin
, testers
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
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    # The minGW toolchain appends a `.exe` if it's not present which confuses
    # `install`.
    ./windows-file-ext.patch
  ] ++ lib.optionals (!buildLmicdiusb) [
    ./disable-lmicdiusb-build.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      AppKit Carbon IOKit
    ]);

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # `lmicdiusb` has no help text so we don't check that it can run.
  doCheck = true;
  passthru.tests = {
    lm4flash = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "${finalAttrs.finalPackage.meta.mainProgram} -V";
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
  };
})
