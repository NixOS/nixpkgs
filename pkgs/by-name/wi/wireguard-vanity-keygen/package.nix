{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-LibNWnjm52iPwrPKAA5v3krADvHcewKuLe9k5HhJgzg=";
  };

  vendorHash = "sha256-sHVdR1zuewT9B4UlPrEWU5V9MjgkwPBh/hkSsn2PQKw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  meta = with lib; {
    changelog =
      let
        versionWithoutDots = concatStrings (splitString "." version);
      in
      "https://github.com/axllent/wireguard-vanity-keygen/blob/develop/CHANGELOG.md#${versionWithoutDots}";
    description = "WireGuard vanity key generator";
    homepage = "https://github.com/axllent/wireguard-vanity-keygen";
    license = licenses.mit;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "wireguard-vanity-keygen";
  };
}
