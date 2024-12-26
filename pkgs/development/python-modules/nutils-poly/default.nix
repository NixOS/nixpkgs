{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  numpy,
  unittestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nutils-poly";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nutils";
    repo = "poly-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-dxFv4Az3uz6Du5dk5KZJ+unVbt3aZjxXliAQZhmBWDM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}";
    inherit src;
    hash = "sha256-+fnKvlSwM197rsyusFH7rs1W6livxel45UGbi1sB05k=";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  build-system = [ rustPlatform.maturinBuildHook ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "nutils_poly" ];

  meta = {
    description = "Low-level functions for evaluating and manipulating polynomials";
    homepage = "https://github.com/nutils/poly-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
