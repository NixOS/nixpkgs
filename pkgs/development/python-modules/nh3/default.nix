{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  rustPlatform,
  libiconv,
  fetchFromGitHub,
  darwin,
}:
let
  pname = "nh3";
  version = "0.2.20";
  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-N+xMS1sb3Qq80eNaI5GUACjCHaCba2d8zZeizayy4kY=";
  };
in
buildPythonPackage {
  inherit pname version src;
  format = "pyproject";
  disabled = pythonOlder "3.8";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-cYdwN/PpG1ae6lBRk5usXSwBjH37BpQEp5JLLQ2NRNU=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Security
  ];

  pythonImportsCheck = [ "nh3" ];

  meta = with lib; {
    description = "Python binding to Ammonia HTML sanitizer Rust crate";
    homepage = "https://github.com/messense/nh3";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
