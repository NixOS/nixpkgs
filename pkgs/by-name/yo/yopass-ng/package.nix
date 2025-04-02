{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "yopass-ng";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "yopass-ng";
    rev = "v${version}";
    hash = "sha256-4ixlEa/ElCWxsD7eBErlq7e0CccwXTiVGb0wFfz8Saw=";
  };

  vendorHash = "sha256-59xKYXd7XjU/go64alrho6o/k1+VhjpP/lTIpxO+h6U=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/yopass-ng/releases/tag/v${version}";
    homepage = "https://paepcke.de/yopass-ng";
    description = "Selfhosted secret sharing service, as convenient, all-in-one embedded, multilingual, hardened single binary";
    license = lib.licenses.bsd3;
    mainProgram = "yopass-ng";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}
