{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "evtx";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    tag = version;
    hash = "sha256-06pRNGEUmk2llD5CPbgHiJSHTR8tm/nv0eJL1UKHPEM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-POEqKRJ/g0bWYs89yrVyD4RFhc7iq+5J67P0rowB2/g=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "evtx" ];

  meta = {
    description = "Bindings for evtx";
    homepage = "https://github.com/omerbenamram/pyevtx-rs";
    changelog = "https://github.com/omerbenamram/pyevtx-rs/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
