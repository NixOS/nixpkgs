{
  lib,
  apple-sdk_14,
  buildGoModule,
  darwin,
  darwinMinVersionHook,
  fetchFromGitHub,
  testers,
  vfkit,
}:

buildGoModule rec {
  pname = "vfkit";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "vfkit";
    rev = "v${version}";
    hash = "sha256-9iPr9VhN60B6kBikdEIFAs5mMH+VcmnjGhLuIa3A2JU=";
  };

  vendorHash = "sha256-6O1T9aOCymYXGAIR/DQBWfjc2sCyU/nZu9b1bIuXEps=";

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
    (darwinMinVersionHook "11")
  ];

  postFixup = ''
    codesign --entitlements vf.entitlements -f -s - $out/bin/vfkit
  '';

  passthru.tests = {
    version = testers.testVersion { package = vfkit; };
  };

  meta = {
    description = "Simple command line tool to start VMs through the macOS Virtualization framework";
    homepage = "https://github.com/crc-org/vfkit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "vfkit";
  };
}
