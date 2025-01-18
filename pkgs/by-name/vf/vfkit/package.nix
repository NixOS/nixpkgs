{
  lib,
  apple-sdk_14,
  buildGoModule,
  darwin,
  fetchFromGitHub,
  nix-update-script,
  testers,
  vfkit,
}:

buildGoModule rec {
  pname = "vfkit";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "vfkit";
    rev = "v${version}";
    hash = "sha256-uBFL3iZLpGcVUSgZSoq8FI87CDAr3NI8uu+u5UsrZCc=";
  };

  vendorHash = "sha256-+5QZcoI+/98hyd87NV6uX/VZqd5z38fk7K7RibX/9vw=";

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
    apple-sdk_14
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
