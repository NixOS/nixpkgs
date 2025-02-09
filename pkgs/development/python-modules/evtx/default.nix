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
  version = "0.8.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    tag = version;
    hash = "sha256-wo6CeHlEBbu3klzzC4dUbjSfu7XwLo/cmtmZsVIKgS8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Zdj0trB0wIVC9xg64wVOIrstdG7LGMOhWcRFXQJGNls=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "evtx" ];

  meta = with lib; {
    description = "Bindings for evtx";
    homepage = "https://github.com/omerbenamram/pyevtx-rs";
    changelog = "https://github.com/omerbenamram/pyevtx-rs/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
