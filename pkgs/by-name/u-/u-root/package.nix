{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  bash,
  nix-update-script,
  u-root-cmds,

  linuxManualConfig,
  fetchurl,
  linux_latest,
}:

buildGoModule (finalAttrs: {
  pname = "u-root";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "u-root";
    repo = "u-root";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QHLVkQJkgTSB9a/QLgl4SKrWje0OhtBpa56zGQK8m+o=";
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
    updateScript = nix-update-script { };
    tests.u-root-cmds = u-root-cmds;
  };

  meta = {
    description = "Fully Go userland with Linux bootloaders";
    longDescription = ''
      u-root can create a one-binary root file system (initramfs) containing a busybox-like set of tools written in Go.

      The package exposes `u-root.kernel-amd64` passthru for a minimal and pre-configured kernel to be used locally with QEMU.

      The u-root commands are available as `u-root-cmds`.
    '';
    homepage = "https://u-root.org/";
    downloadPage = "https://github.com/u-root/u-root";
    changelog = "https://github.com/u-root/u-root/blob/${finalAttrs.src.rev}/RELEASES";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "u-root";
    platforms = lib.platforms.linux;
  };
})
