{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xcaddy";
  version = "0.4.4";

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vpaweUU++3ZHj7KT5WNUCw3X93sQBTgjKlB8rJwrHlM=";
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

  vendorHash = "sha256-vU/ptOzBjMpRG2Do6ODC+blcCNl15D9mSsEV8QgNN3Y=";

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
