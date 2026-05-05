{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libxcrypt-legacy,
}:
buildPythonPackage rec {
  pname = "deprecated-crypt-alternative";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "youknowone";
    repo = "python-deadlib";
    tag = "v${version}";
    hash = "sha256-vhGFTd1yXL4Frqli5D1GwOatwByDjvcP8sxgkdu6Jqg=";
  };

  sourceRoot = "${src.name}/_crypt";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-KR1fOqextBFpGLytZsEyBQALEhAnP3LT2E5VaaOqkS0=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [ libxcrypt-legacy ];

  nativeCheckInputs = [ rustPlatform.cargoCheckHook ];

  meta = {
    homepage = "https://github.com/youknowone/python-deadlib";
    license = lib.licenses.lgpl2;
    maintainers = [ lib.maintainers.quantenzitrone ];
  };
}
