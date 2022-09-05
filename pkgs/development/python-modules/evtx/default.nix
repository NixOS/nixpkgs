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
  version = "0.7.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    rev = version;
    sha256 = "sha256-59iEmgF1m+Yr5k4oxZGqMs5oMZxToUFYuwQDeLEQ2jY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-Q2SpJohLSQCMYmx1ZMWZ7a/NC0lPsHkwxom00qVooNM=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  checkInputs = [
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
