{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

buildPythonPackage (finalAttrs: {
  pname = "ruff-format";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "ruff-format";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7XWeEcvbsVffaDbGDW2251qaZtUj6Sip3TEs9lytoo8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-D19Irgy8kh14neAJDMlNRQ81qyYB8NNZ25wxjbUk7wk=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [
    "ruff_format"
  ];

  meta = {
    description = "Fast Python code formatter";
    homepage = "https://github.com/reflex-dev/ruff-format";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
})
