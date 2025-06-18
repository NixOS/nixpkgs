{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  rustPlatform,
  libiconv,
  fetchFromGitHub,
}:
let
  pname = "nh3";
  version = "0.2.21";
  src = fetchFromGitHub {
    owner = "messense";
    repo = "nh3";
    rev = "v${version}";
    hash = "sha256-DskjcKjdz1HmKzmA568zRCjh4UK1/LBD5cSIu7Rfwok=";
  };
in
buildPythonPackage {
  inherit pname version src;
  format = "pyproject";
  disabled = pythonOlder "3.8";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-1Ytca/GiHidR8JOcz+DydN6N/iguLchbP8Wnrd/0NTk=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  pythonImportsCheck = [ "nh3" ];

  meta = with lib; {
    description = "Python binding to Ammonia HTML sanitizer Rust crate";
    homepage = "https://github.com/messense/nh3";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
