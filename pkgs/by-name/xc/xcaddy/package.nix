{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xcaddy";
  version = "0.4.2";

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4evqpkDb6/sduPuqRlnvvi/kS4H2zpYB8LB2PXmoopA=";
  };

  patches = [
    ./inject_version_info.diff
    ./use_tmpdir_on_darwin.diff
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/xcaddy/cmd.customVersion=v${version}"
  ];

  vendorHash = "sha256-NoOEvvaD3oUejlFIe1s95SjL/YRsuCSHFElnxaweA/s=";

  meta = with lib; {
    homepage = "https://github.com/caddyserver/xcaddy";
    description = "Build Caddy with plugins";
    mainProgram = "xcaddy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      tjni
      emilylange
    ];
  };
}
