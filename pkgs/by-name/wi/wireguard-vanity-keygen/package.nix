{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-L+YssChpGNQs2MLGXul1sxVmROOWfT0aaZMepGuKmEQ=";
  };

  vendorHash = "sha256-kAPw5M9o99NijCC9BzYhIpzHK/8fSAJxvckaj8iRby0=";

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
