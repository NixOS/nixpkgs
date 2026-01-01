{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "astropy-iers-data";
<<<<<<< HEAD
  version = "0.2025.11.24.0.39.11";
=======
  version = "0.2025.8.4.0.42.59";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astropy-iers-data";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-B8568fGvS76igIlEWIbsTczQYqL0nPISM8rfUrF/DS4=";
=======
    hash = "sha256-Izqm626PZzjnMNUzPW2x15ER7fn5f9+m2X434vXV/yo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonImportsCheck = [ "astropy_iers_data" ];

  # no tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/astropy/astropy-iers-data/releases/tag/${src.tag}";
    description = "IERS data maintained by @astrofrog and astropy.utils.iers maintainers";
    homepage = "https://github.com/astropy/astropy-iers-data";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "IERS data maintained by @astrofrog and astropy.utils.iers maintainers";
    homepage = "https://github.com/astropy/astropy-iers-data";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
