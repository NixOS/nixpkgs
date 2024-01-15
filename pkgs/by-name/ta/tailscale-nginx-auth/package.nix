{ lib, stdenv, buildGoModule, fetchFromGitHub }:

let
  version = "1.56.1";
in
buildGoModule {
  pname = "tailscale-nginx-auth";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "v${version}";
    hash = "sha256-kMk5Q/KvNcsohHNLDMmpBm+gUxQEOeO8o/odukcJi0A=";
  };
  vendorHash = "sha256-bG/ydsJf2UncOcDo8/BXdvQJO3Mk0tl8JGje1b6kto4=";

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
    maintainers = with maintainers; [ danderson phaer ];
  };
}
