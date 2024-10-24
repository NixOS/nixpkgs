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
  version = "0.2.17";
  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j9OoXAuuCWsBHanN+SzSip94ZA+kY8HUVvfY/omUSSM=";
  };
in
buildPythonPackage {
  inherit pname version src;
  format = "pyproject";
  disabled = pythonOlder "3.6";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-WomlVzKOUfcgAWGJInSvZn9hm+bFpgc4nJbRiyPCU64=";
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
