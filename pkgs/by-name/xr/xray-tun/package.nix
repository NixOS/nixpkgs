{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "xray-tun";
  version = "0.0.8-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "goxray";
    repo = "tun";
    rev = "0d07c6bbe69cc5c73f6a0e82cdf78be8f85d9738";
    hash = "sha256-cy/0/OEt4mbMhwpinjFmZfkIMXhWy5JmhNQLvSjULGs=";
  };

  vendorHash = "sha256-jNGjpXjuaFU/WbedE87sUGo1pq+MLaMIFqeIOp8m1wk=";

  postInstall = ''
    mv $out/bin/tun $out/bin/xray-tun
  '';

  meta = {
    description = "CLI Xray VPN client";
    homepage = "https://github.com/goxray/tun";
    license = lib.licenses.mit;
    mainProgram = "xray-tun";
    maintainers = with lib.maintainers; [ lalala ];
  };
}
