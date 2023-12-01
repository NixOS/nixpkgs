{ lib
, appdirs
, build
, buildPythonPackage
, fetchFromGitHub
, hatchling
, hatch-vcs
, magicgui
, napari # reverse dependency, for tests
, pydantic
, pythonOlder
, pytomlpp
, pyyaml
, rich
, typer
}:

buildPythonPackage rec {
  pname = "napari-npe2";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "npe2";
    rev = "refs/tags/v${version}";
    hash = "sha256-PjoLocNTkcAnBNRbPi+MZqZtQ2bjWPIUVz0+k8nIn2A=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
  ];

  pythonImportsCheck = [
    "npe2"
  ];

  passthru.tests = { inherit napari; };

  meta = with lib; {
    description = "Plugin system for napari (the image visualizer)";
    homepage = "https://github.com/napari/npe2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
