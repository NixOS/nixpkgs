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
  version = "0.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "pyevtx-rs";
    rev = version;
    sha256 = "sha256-MSQYp/qkntFcnGqGhJ+0i4eMGzcDJcSZ44qFARMYM2I=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-kzv2ppRjkmXgMxJviBwRVXMiGWBlhBqLXEmmRvwlw98=";
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
