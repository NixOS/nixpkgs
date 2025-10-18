{
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
  rustc,
  perl,
  lib,
# pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "impit";
  version = "0.7.1";
  pyproject = true;

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
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
    perl
  ];

  pythonImportsCheck = [ "impit" ];

  # nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "HTTP client with automatic browser fingerprint generation";
    homepage = "https://github.com/apify/impit";
    changelog = "https://github.com/apify/impit/releases/tag/py-${version}";
    licenses = lib.licenses.asl20;
    maintainers = [ lib.maintainers.monk3yd ];
  };
}
