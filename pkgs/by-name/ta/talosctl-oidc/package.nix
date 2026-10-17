{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "talosctl-oidc";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "qjoly";
    repo = "talosctl-oidc";
    rev = "v${version}";
    hash = "sha256-U4y9cKjspXwxOBdYad3NiDfZmmnVSoyIURy0uF+8fqM=";
  };

  vendorHash = "sha256-hpQ+Bvppu+8x8+Fd/y6A47E4zgBNx/ZK74Z7ZI/aW8o=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=v${version}"
    "-X main.date=unknown"
  ];

  meta = with lib; {
    description = "OIDC certificate exchange server and client for Talos Linux";
    homepage = "https://github.com/qjoly/talosctl-oidc";
    changelog = "https://github.com/qjoly/talosctl-oidc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
    mainProgram = "talosctl-oidc";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
