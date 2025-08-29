{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  tqdm,
  basic-colormath,
  unstableGitUpdater,
  setuptools,
}:
buildPythonPackage {
  pname = "color-manager";
  version = "0-unstable-2024-11-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NicklasVraa";
    repo = "Color-manager";
    rev = "9e55e0971ecd0e3141ed5d7d9a8377f7052cef96";
    hash = "sha256-kXRjp1sFgSiIQC9+fUQcNRK990Hd5nZwJpRGB7qRYrY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tqdm
    basic-colormath
  ];

  doCheck = false;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Recolor icon packs, themes, wallpapers and assets with a few clicks or lines of code";
    homepage = "https://github.com/NicklasVraa/Color-manager";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
