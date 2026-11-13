{
  lib,
  apple-sdk_15,
  buildGoModule,
  darwin,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
  testers,
  vfkit,
}:

buildGoModule rec {
  pname = "vfkit";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "vfkit";
    rev = "v${version}";
    hash = "sha256-AHmCmDrddbPM8agM4jyKGKJ5aJSZ0hijM2suHJmRS3A=";
  };

  vendorHash = "sha256-tXpjEMF4wwuP4w8asZPpeA8C5g+k4MjNRtbCBFFql2A=";

  subPackages = [ "cmd/vfkit" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/crc-org/vfkit/pkg/cmdline.gitVersion=${src.rev}"
  ];

  nativeBuildInputs = [
    darwin.sigtool
  ];

  buildInputs = [
    apple-sdk_15
  ];

  postFixup = ''
    codesign --entitlements vf.entitlements -f -s - $out/bin/vfkit
  '';

  passthru.tests = {
    version = testers.testVersion { package = vfkit; };
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple command line tool to start VMs through the macOS Virtualization framework";
    homepage = "https://github.com/crc-org/vfkit";
    changelog = "https://github.com/crc-org/vfkit/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarcasticadmin
      phaer
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "vfkit";
  };
}
