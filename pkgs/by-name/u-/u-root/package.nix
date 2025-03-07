{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  bash,

  linuxManualConfig,
  fetchurl,
  linux_latest,
}:

buildGoModule rec {
  pname = "u-root";
  version = "0.14.0-unstable-2024-09-26";

  src = fetchFromGitHub {
    owner = "u-root";
    repo = "u-root";
    rev = "a620c4fc0eeeaa71ea68c27d6ef96352ed814829";
    hash = "sha256-8B2H3AwGo9friveBk4bijOph9bSSNR7PPKJYEuywgm4=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  env.CGO_ENABLED = "0";

  ldflags = [ "-s" ];

  allowGoReference = true;

  # The tests want to copy /bin/bash and /bin/ls, but we don't have those.
  # As these are interesting e2e tests to check if things work, we substitute
  # them with the actual paths instead of just skipping the tests.
  preCheck = ''
    substituteInPlace ./uroot_test.go \
      --replace-fail '-files=/bin/bash"' '-files=${bash}/bin/bash:bin/bash"' \
      --replace-fail '-files=/bin/ls"' '-files=${coreutils}/bin/ls:bin/ls"' \
      --replace-fail '-files=/bin/bash' '-files=${bash}/bin/bash'
  '';

  passthru = {
    # Somewhat minimal kernel config for Go/u-root, used by upstream for testing.
    # This can be used to quickly run u-root locally with proper serial console output.
    kernel-amd64 = linuxManualConfig {
      inherit (linux_latest) version src;
      configfile = fetchurl {
        url = "https://raw.githubusercontent.com/hugelgupf/vmtest/5d9f3d34a58dc7b13bca786e8ac32d3e2ce4e95d/images/kernel-amd64/config_linux.txt";
        hash = "sha256-CjhWWK6YwSOXP10mpnJjG5nwLWs2cDtebvlDBLzN5fI=";
      };
      allowImportFromDerivation = true;
    };
  };

  meta = {
    description = "A fully Go userland with Linux bootloaders";
    longDescription = ''
      u-root can create a one-binary root file system (initramfs) containing a busybox-like set of tools written in Go.

      The package exposes `u-root.kernel-amd64` passthru for a minimal and pre-configured kernel to be used locally with QEMU.
    '';
    homepage = "https://u-root.org/";
    downloadPage = "https://github.com/u-root/u-root";
    changelog = "https://github.com/u-root/u-root/blob/${src.rev}/RELEASES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "u-root";
    platforms = lib.platforms.linux;
  };
}
