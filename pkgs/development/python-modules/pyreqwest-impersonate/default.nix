{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytest,
  runCommand,
  boringssl,
  libiconv,
  SystemConfiguration,
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
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deedy5";
    repo = "pyreqwest_impersonate";
    rev = "v${version}";
    hash = "sha256-U22NNYN8p3IQIAVb6dOrErFvuJ5m5yXi2ELbyuaNlFc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-rj9tfOzhzfWBoxBGlTXHAmiH5qxyoLnHhlEijy/q+Ws=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    SystemConfiguration
  ];

  env.BORING_BSSL_PATH = boringssl-wrapper;

  passthru.optional-dependencies = {
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
