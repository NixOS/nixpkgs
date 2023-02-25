{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, rustPlatform
}:

buildPythonPackage rec {
  pname = "evtx";
  version = "0.8.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    rev = version;
    sha256 = "sha256-t//oNvD+7wnv5KkriKBX4xgGS8pQpZgCsKxAEXsj0X8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-DPEL36cYNV5v4iW3+Fg1eEeuBuK9S7Qe78xOzZs8aJw=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "evtx"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Bindings for evtx";
    homepage = "https://github.com/omerbenamram/pyevtx-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
