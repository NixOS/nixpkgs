{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.12.3";
in
buildGoModule {
  pname = "wakapi";
  inherit version;

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    tag = version;
    hash = "sha256-kgzxeU5hM9fSidyJEmdTr26/w5OaBk1VdjSztmOgMYs=";
  };

  vendorHash = "sha256-q5o88fwc1S14ZwGyDS9aFtJMfPZ4pmMjffmeXODhajg=";

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  # Fix up reported version
  postPatch = ''echo ${version} > version.txt'';

  ldflags = [
    "-s"
    "-w"
  ];

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
