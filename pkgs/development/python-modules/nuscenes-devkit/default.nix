# Introduced as a dependency for python3Packages.nerfstudio

{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  setuptools,
  wheel,
  cachetools,
  descartes,
  fire,
  matplotlib,
  numpy,
  opencv4,
  pillow,
  pyquaternion,
  scikit-learn,
  scipy,
  shapely,
  tqdm,
  parameterized,
}:

stdenv.mkDerivation rec {
  pname = "nuscenes-devkit";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nutonomy";
    repo = "nuscenes-devkit";
    rev = version;
    hash = "sha256-1EW/9KZskWI+BXhHs2aiX+OfiJY3aGrqyRweQ7gTLZU=";
  };

  sourceRoot = "${src.name}/setup";

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    cachetools
    descartes
    fire
    matplotlib
    numpy
    opencv4
    pillow
    pyquaternion
    scikit-learn
    scipy
    shapely
    tqdm
    parameterized
  ];

  meta = {
    description = "The devkit of the nuScenes dataset";
    homepage = "https://github.com/nutonomy/nuscenes-devkit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SomeoneSerge  ];
    mainProgram = "nuscenes-devkit";
  };
}
