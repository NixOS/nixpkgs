{
  lib,
  stdenv,
  buildGoModule,
  tailscale,
}:

buildGoModule {
  pname = "tailscale-nginx-auth";
  inherit (tailscale) version src vendorHash;

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/nginx-auth" ];

  ldflags = [
    "-w"
    "-s"
    "-X tailscale.com/version.longStamp=${tailscale.version}"
    "-X tailscale.com/version.shortStamp=${tailscale.version}"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mv $out/bin/nginx-auth $out/bin/tailscale.nginx-auth
    sed -i -e "s#/usr/sbin#$out/bin#" ./cmd/nginx-auth/tailscale.nginx-auth.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/nginx-auth/tailscale.nginx-auth.service
    install -D -m0444 -t $out/lib/systemd/system ./cmd/nginx-auth/tailscale.nginx-auth.socket
  '';

  meta = {
    homepage = "https://tailscale.com";
    description = "Tool that allows users to use Tailscale Whois authentication with NGINX as a reverse proxy";
    license = lib.licenses.bsd3;
    mainProgram = "tailscale.nginx-auth";
    maintainers = with lib.maintainers; [ phaer ];
  };
}
