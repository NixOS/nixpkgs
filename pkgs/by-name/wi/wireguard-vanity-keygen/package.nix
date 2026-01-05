{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-IF5z0qkVOzcwVQNfem18DTn6KbEjjPspGfneG1ekGJI=";
  };

  vendorHash = "sha256-dYpkAdOjiXm1REGsUUTRb8de6okdZ9GpKppBnb6oo9g=";

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
