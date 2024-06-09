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
  version = "0.7.2-unstable-2023-10-20";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "npe2";
    rev = "9d29e4d6dbbec75c2d36273647efd9ddfb59ded0";
    hash = "sha256-JLu/5pXijPdpKY2z2rREtSKPiP33Yy4viegbxUiQg7Y=";
  };

  # fix this in the next release
  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.7.2";

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
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
    mainProgram = "npe2";
    homepage = "https://github.com/napari/npe2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
