{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cargo,
  pkg-config,
  rustc,
  rustfmt,
  setuptools-rust,
  openssl,
  msgpack,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "etebase";
  version = "0.31.8";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etebase-py";
    rev = "v${version}";
    hash = "sha256-V2mQAYIPyDRQMfT0af2mpKfWXAtnJpRmY5qG1hj2dF4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-e7KNysHeZvHLttHKvG//uP5ebIsUiW0uwXsASVpWh58=";
  };

  pyproject = true;

  nativeBuildInputs = [
    pkg-config
    rustfmt
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [ msgpack ];

  postPatch = ''
    # Use system OpenSSL, which gets security updates.
    substituteInPlace Cargo.toml \
      --replace ', features = ["vendored"]' ""
  '';

  pythonImportsCheck = [ "etebase" ];

  passthru.tests = {
    inherit (nixosTests) etebase-server;
  };

  meta = {
    homepage = "https://www.etebase.com/";
    description = "Python client library for Etebase";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
