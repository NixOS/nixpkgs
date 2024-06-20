{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  runCommand,
  boringssl,
}:

let
  # boring-sys expects the static libraries in build/ instead of lib/
  boringssl-wrapper = runCommand "boringssl-wrapper" { } ''
    mkdir $out
    cd $out
    ln -s ${boringssl.out}/lib build
    ln -s ${boringssl.dev}/include include
  '';
in
buildPythonPackage rec {
  pname = "pyreqwest-impersonate";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "pyreqwest_impersonate";
    rev = "v${version}";
    hash = "sha256-ck5RqSUgnLAjZ+1A1wQRyRMahJRq3nzYvE+WBpu6wk0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-eGmx4ftS1D7qb2pPZxp4XE44teXcRwKs3tcKm8otsaM=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  env.BORING_BSSL_PATH = boringssl-wrapper;

  optional-dependencies = {
    dev = [ pytest ];
  };

  # Test use network
  doCheck = false;

  pythonImportsCheck = [ "pyreqwest_impersonate" ];

  meta = {
    description = "HTTP client that can impersonate web browsers (Chrome/Edge/OkHttp/Safari), mimicking their headers and TLS/JA3/JA4/HTTP2 fingerprints";
    homepage = "https://github.com/deedy5/pyreqwest_impersonate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
