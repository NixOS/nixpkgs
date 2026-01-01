{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  libiconv,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "ruff-api";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amyreese";
    repo = "ruff-api";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4ekNPgOOqRIVjIR8LNSALE7fByjMEn8y25y9Rdvf+ms=";
=======
    hash = "sha256-+tGBaHEau2OjAjj452wEAQ4gyxczg6Fb+NJ42oIkKQY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-SqouHcEDehxNnNPdrkDUYx8AieHiPMs04RgrkdqYcpU=";
=======
    hash = "sha256-cpW2XsrQvFC5wkGF8hBQ7xFp5oLEJpbHuHBLi6VFkEo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # Tests have issues at the moment, check with next update
  doCheck = false;

  pythonImportsCheck = [ "ruff_api" ];

  meta = {
    description = "Experimental Python API for Ruff";
    homepage = "https://github.com/amyreese/ruff-api";
    changelog = "https://github.com/amyreese/ruff-api/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
