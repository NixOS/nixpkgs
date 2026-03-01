{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "trojan-go";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "p4gefau1t";
    repo = "trojan-go";
    tag = "v${version}";
    hash = "sha256-ZzIEKyLhHwYEWBfi6fHlCbkEImetEaRewbsHQEduB5Y=";
  };

  vendorHash = "sha256-c6H/8/dmCWasFKVR15U/kty4AzQAqmiL/VLKrPtH+s4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/p4gefau1t/trojan-go/constant.Version=v${version}"
    "-X github.com/p4gefau1t/trojan-go/constant.Commit=v${version}"
  ];

  tags = [
    "api"
    "client"
    "server"
    "forward"
    "nat"
    "other"
  ];

  # tests fail due to requiring networking
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Proxy mechanism to bypass GFW";
    homepage = "https://p4gefau1t.github.io/trojan-go/";
    changelog = "https://github.com/p4gefau1t/trojan-go/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.gpl3Only;
    mainProgram = "trojan-go";
  };
}
