{
  lib,
  appdirs,
  build,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  magicgui,
  napari, # reverse dependency, for tests
  pydantic,
  pythonOlder,
  pytomlpp,
  pyyaml,
  rich,
  typer,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "napari-npe2";
  version = "0.7.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "npe2";
    rev = "refs/tags/v${version}";
    hash = "sha256-HjMf5J1n5NKqtunRQ7cqZiTZMTNmcq5j++O03Sxwvqw=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    appdirs
    build
    magicgui
    pydantic
    pytomlpp
    pyyaml
    rich
    typer
    tomli-w
  ];

  pythonImportsCheck = [ "npe2" ];

  passthru.tests = {
    inherit napari;
  };

  meta = with lib; {
    description = "Plugin system for napari (the image visualizer)";
    homepage = "https://github.com/napari/npe2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
    mainProgram = "npe2";
  };
}
