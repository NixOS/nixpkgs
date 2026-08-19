{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage (finalAttrs: {
  pname = "astropy-iers-data";
  version = "0.2026.6.22.1.23.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astropy-iers-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q3uW3G3WTHpaRC54tO7ytmSg65SMaOQKO5KbqaSxeq4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonImportsCheck = [ "astropy_iers_data" ];

  # no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/astropy/astropy-iers-data/releases/tag/${finalAttrs.src.tag}";
    description = "IERS data maintained by @astrofrog and astropy.utils.iers maintainers";
    homepage = "https://github.com/astropy/astropy-iers-data";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
