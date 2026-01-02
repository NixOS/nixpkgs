{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  pythonOlder,
  pyyaml,
  platformdirs,
  build,
  psygnal,
  pydantic,
  tomli-w,
  tomli,
  rich,
  typer,
  napari, # reverse dependency, for tests
}:

buildPythonPackage rec {
  pname = "napari-npe2";
  version = "0.7.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "npe2";
    tag = "v${version}";
    hash = "sha256-q+vgzUuSSHFR64OajT/j/tLsNgSm3azQPCvDlrIvceM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pyyaml
    platformdirs
    build
    psygnal
    pydantic
    tomli-w
    rich
    typer
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [ "npe2" ];

  passthru.tests = {
    inherit napari;
  };

  meta = {
    description = "Plugin system for napari (the image visualizer)";
    homepage = "https://github.com/napari/npe2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "npe2";
  };
}
