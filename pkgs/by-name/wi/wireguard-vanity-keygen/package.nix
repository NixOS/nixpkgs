{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-vAHVhW2BYND1Lz8WEFbbuJRMP7dXzZXQR8/bewb/ZUg=";
  };

  vendorHash = "sha256-iBpfSS/T5xgYS0xiH5wNR7jfMdhW8t2LchXAx84YYHM=";

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
