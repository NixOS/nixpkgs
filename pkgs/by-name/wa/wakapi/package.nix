{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:
let
  version = "2.13.1";
in
buildGoModule {
  pname = "wakapi";
  inherit version;

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    tag = version;
    hash = "sha256-zasMqEvSqylJWKjS5TKYKmGJnGfCUEOq2UvsVUeizBw=";
  };

  vendorHash = "sha256-b2FOdCXmSgFzdXLnxt/V7+cuESWXVXVRmT53DgLwZYI=";

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
