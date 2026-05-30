{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-5N+D1wVrqUvkyxXKzIZPRdSPpHcPZp1Fzo2AwYA7Ue8=";
  };

  vendorHash = "sha256-hYNQVYNpMqi656GlaMehG5U48IKtJIxJ5QPxPWMmpzg=";

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  meta = {
    changelog =
      let
        versionWithoutDots = lib.concatStrings (lib.splitString "." version);
      in
      "https://github.com/axllent/wireguard-vanity-keygen/blob/develop/CHANGELOG.md#${versionWithoutDots}";
    description = "WireGuard vanity key generator";
    homepage = "https://github.com/axllent/wireguard-vanity-keygen";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "wireguard-vanity-keygen";
  };
}
