{ lib, buildGoModule, darwin, fetchFromGitHub }:

buildGoModule rec {
  pname = "vfkit";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "crc-org";
    repo = "vfkit";
    rev = "v${version}";
    hash = "sha256-NoaJ60bCmhI1S9pPyHYTmYdqWm17eF/CsTBBwkOwT1I=";
  };

  overrideModAttrs = _: {
    postBuild = ''
      patch -p0 < ${./darwin-os-version.patch}
      patch -p0 < ${./support-apple-11-sdk.patch}
    '';
  };

  vendorHash = "sha256-TX+vm4FhBaM0WNXA+m7rmaWZR+Lk9f2Z8UJXMd2yzDw=";

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
    darwin.apple_sdk_11_0.frameworks.Cocoa
    darwin.apple_sdk_11_0.frameworks.Virtualization
  ];

  postFixup = ''
    codesign --entitlements vf.entitlements -f -s - $out/bin/vfkit
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Simple command line tool to start VMs through virtualization framework";
    homepage = "https://github.com/crc-org/vfkit";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.darwin;
    mainProgram = "vfkit";
  };
}
