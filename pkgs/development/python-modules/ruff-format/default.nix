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
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reflex-dev";
    repo = "ruff-format";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nhcp3FsV0S9MRnoCt5zYrZYoDg6R9ELYTdicLITVmUA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-UBEH7Wmuf46xS8oGEpdqh9Yq7jcwbZheE96D7rLMoe0=";
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
