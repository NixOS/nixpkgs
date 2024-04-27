{ lib, stdenv, buildGoModule, fetchFromGitHub }:

let
  version = "1.64.2";
in
buildGoModule {
  pname = "tailscale-nginx-auth";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    hash = "sha256-DS7C/G1Nj9gIjYwXaEeCLbtH9HbB0tRoJBDjZc/nq5g=";
  };
  vendorHash = "sha256-pYeHqYd2cCOVQlD1r2lh//KC+732H0lj1fPDBr+W8qA=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/nginx-auth" ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${version}"
    "-X tailscale.com/version.shortStamp=${version}"
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    mv $out/bin/nginx-auth $out/bin/tailscale.nginx-auth
    sed -i -e "s#/usr/sbin#$out/bin#" ./cmd/nginx-auth/tailscale.nginx-auth.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/nginx-auth/tailscale.nginx-auth.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/nginx-auth/tailscale.nginx-auth.socket
  '';

  meta = with lib; {
    homepage = "https://tailscale.com";
    description = "Tool that allows users to use Tailscale Whois authentication with NGINX as a reverse proxy.";
    license = licenses.bsd3;
    mainProgram = "tailscale.nginx-auth";
    maintainers = with maintainers; [ phaer ];
  };
}
