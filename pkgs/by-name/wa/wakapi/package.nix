{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
let
  version = "2.14.1";
in
buildGoModule {
  pname = "wakapi";
  inherit version;

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    tag = version;
    hash = "sha256-ujHrb9yXUbUYB0JGftrdTfEeFakgwGJ7EH6e1KnyrnI=";
  };

  vendorHash = "sha256-eaaU8vqTpgtSSfaaFDg4Bo06lTjvqLkVuidkq25tjb4=";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  # Fix up reported version
  postPatch = ''echo ${version} > version.txt'';

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    nixos = nixosTests.wakapi;
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://wakapi.dev/";
    changelog = "https://github.com/muety/wakapi/releases/tag/${version}";
    description = "Minimalist self-hosted WakaTime-compatible backend for coding statistics";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      t4ccer
      isabelroses
    ];
    mainProgram = "wakapi";
  };
}
