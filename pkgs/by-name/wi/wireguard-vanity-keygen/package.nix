{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-qTVPPr7lmjMvUqetDupZCo8RdoBHr++0V9CB4b6Bp4Y=";
  };

  vendorHash = "sha256-9/waDAfHYgKh+FsGZEp7HbgI83urRDQPuvtuEKHOf58=";

  ldflags = [ "-s" "-w" "-X main.appVersion=${version}" ];

  meta = with lib; {
    changelog = let
      versionWithoutDots = concatStrings (splitString "." version);
    in "https://github.com/axllent/wireguard-vanity-keygen/blob/develop/CHANGELOG.md#${versionWithoutDots}";
    description = "WireGuard vanity key generator";
    homepage = "https://github.com/axllent/wireguard-vanity-keygen";
    license = licenses.mit;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "wireguard-vanity-keygen";
  };
}
