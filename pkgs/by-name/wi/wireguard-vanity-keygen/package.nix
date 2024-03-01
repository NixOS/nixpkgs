{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wireguard-vanity-keygen";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "axllent";
    repo = "wireguard-vanity-keygen";
    rev = version;
    hash = "sha256-+q6l2531APm67JqvFNQb4Zj5pyWnHgncwxcgWNiBCJw=";
  };

  vendorHash = "sha256-F3AoN8NgXjePy7MmI8jzLDxaIZBCfOPRbe0ZYmt6vm8=";

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
