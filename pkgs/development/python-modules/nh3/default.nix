{
  lib,
  stdenv,
  buildPythonPackage,
  rustPlatform,
  libiconv,
  fetchFromGitHub,
}:
let
  pname = "nh3";
  version = "0.3.2";
  src = fetchFromGitHub {
    owner = "messense";
    repo = "nh3";
    rev = "v${version}";
    hash = "sha256-2D8ZLmVRA+SuMqeUsSXyY+0zlgqp7TSRyQuJMjmRVFk=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-dN6zdwMGh8stgDuGiO+T/ZZ3/3P9Wu/gUw5gHJ1pPGA=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  pythonImportsCheck = [ "nh3" ];

  meta = {
    description = "Python binding to Ammonia HTML sanitizer Rust crate";
    homepage = "https://github.com/messense/nh3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
