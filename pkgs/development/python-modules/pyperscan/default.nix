{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pytestCheckHook
, libiconv
, vectorscan
}:

buildPythonPackage rec {
  pname = "pyperscan";
  version = "0.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "pyperscan";
    rev = "v${version}";
    hash = "sha256-ioNGEmWy+lEzazF1RzMFS06jYLNYll3QSlWAF0AoU7Y=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2zppyxJ+XaI/JCkp7s27/jgtSbwxnI4Yil5KT8WgrVI=";
  };

  nativeBuildInputs = with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ];

  checkInputs = [ pytestCheckHook ];

  buildInputs = [ vectorscan ] ++ lib.optional stdenv.isDarwin libiconv;

  # Disable default features to use the system vectorscan library instead of a vendored one.
  maturinBuildFlags = [ "--no-default-features" ];

  pythonImportsCheck = [ "pyperscan" ];

  meta = with lib; {
    description = "a hyperscan binding for Python, which supports vectorscan";
    homepage = "https://github.com/vlaci/pyperscan";
    platforms = platforms.unix;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ tnias vlaci ];
  };
}
