{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-TpfSowOS1dNKIcoTV1hTnMzEbAax8uwYoan3SIJ03Lc=";
  };

  vendorHash = "sha256-eh7zTM88qgXKqmhf1WyWsKve+YneQAUji2mDMEHUCIA=";

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
