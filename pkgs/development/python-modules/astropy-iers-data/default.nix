{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "astropy-iers-data";
  version = "0.2025.11.24.0.39.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astropy-iers-data";
    tag = "v${version}";
    hash = "sha256-B8568fGvS76igIlEWIbsTczQYqL0nPISM8rfUrF/DS4=";
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
