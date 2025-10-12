{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  maturin,
  puccinialin,
  build,
  hatchling,
  setuptools,
  cargo,
  rustc,
  perl,
}:
buildPythonPackage rec {
  pname = "impit";
  version = "0.7.1";
  format = "pyproject";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wK7e2InQi33vpGUqzAxloC9rpdlUTfbzC7BFiUif5t0=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-LH3cDn16VWSNk8xYk7l5AvnmoMk3dgdi+LSjq6vcAns=";
  };
  RUSTFLAGS = "--cfg reqwest_unstable";
  nativeBuildInputs = [
    build
    hatchling
    setuptools
    maturin
    puccinialin
    rustPlatform.cargoSetupHook
    cargo
    rustc
    perl
  ];
  pythonImportsCheck = [ "impit" ];
  meta = with lib; {
    description = "HTTP client with automatic browser fingerprint generation";
    homepage = "https://github.com/apify/impit";
    license = licenses.asl20;
    maintainers = with maintainers; [ monk3yd ];
  };
}
