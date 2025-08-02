{
  lib,
  nixosTests,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "vencloud";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Vencord";
    repo = "Vencloud";
    tag = "v${version}";
    hash = "sha256-u++1qWH04MKipnTGo04FVS+HYcx52AWZpBcjiFMp+mY=";
  };

  vendorHash = "sha256-4g3mGMhsBaJ4N8SEj56sjAgfH5v8J2RD5c5tMLk5hGU=";

  passthru = {
    tests = {
      inherit (nixosTests) vencloud;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Vencord's API for cloud settings sync";
    homepage = "https://github.com/Vencord/Vencloud";
    changelog = "https://github.com/Vencord/Vencloud/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "backend";
  };
}
