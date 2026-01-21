{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "astropy-iers-data";
  version = "0.2026.1.19.0.42.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astropy-iers-data";
    tag = "v${version}";
    hash = "sha256-psxVL7375xQuo6mqh+5rvv0xEuZNUOtFco1BrPPWLtg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonImportsCheck = [ "astropy_iers_data" ];

  # no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/astropy/astropy-iers-data/releases/tag/${src.tag}";
    description = "IERS data maintained by @astrofrog and astropy.utils.iers maintainers";
    homepage = "https://github.com/astropy/astropy-iers-data";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
