{
  lib,
  buildGo123Module,
  fetchFromGitHub,
}:
let
  version = "2.12.0";
in
buildGo123Module {
  pname = "wakapi";
  inherit version;

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    rev = "refs/tags/${version}";
    hash = "sha256-/aacT/VLA5S4PeGcxEGaCpgAw++b3VFD7T0CldZWcQI=";
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
