{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.12.1";
in
buildGoModule {
  pname = "wakapi";
  inherit version;

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    rev = "refs/tags/${version}";
    hash = "sha256-+JxTszBa6rURm0vPy8Oke5/hX9EmDphWEp2eglS+SFU=";
  };

  vendorHash = "sha256-Q56Ud0MtkstB/dhn+QyAHTzIqHsmKvHEK+5PAt5lIMM=";

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
