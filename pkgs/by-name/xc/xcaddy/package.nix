{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xcaddy";
  version = "0.4.5";

  subPackages = [ "cmd/xcaddy" ];

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "xcaddy";
    rev = "v${version}";
    hash = "sha256-2cP0bkG16bRdLycLx7gpnQuALgO8hDowp/4cRBO4KuM=";
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

  vendorHash = "sha256-2OZoSOUCkt94uG+54Dx/1di/RZxZ2UOsmTC6YDA5cKo=";

  meta = with lib; {
    homepage = "https://github.com/caddyserver/xcaddy";
    description = "Build Caddy with plugins";
    mainProgram = "xcaddy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      tjni
    ];
  };
}
