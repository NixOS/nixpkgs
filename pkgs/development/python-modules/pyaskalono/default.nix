{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pyaskalono";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kumekay";
    repo = "pyaskalono";
    tag = "v${version}";
    hash = "sha256-gNQCtubPs8XjE+ZTuTTzZGkxOhK3/Fv3lDLparaUdaQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-rQP6So9tG/9cjB588v+6lp2h+0SjaiWPhKrSXgDYugE=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "askalono" ];

  meta = {
    description = "Python wrapper for askalono";
    homepage = "https://github.com/kumekay/pyaskalono/";
    changelog = "https://github.com/kumekay/pyaskalono/releases/tag/v${version}";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
