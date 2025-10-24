{
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildPythonPackage,
  unittestCheckHook,
  pythonOlder,
  cargo,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "aiotarfile";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rhelmot";
    repo = "aiotarfile";
    tag = "v${version}";
    hash = "sha256-V88cvVw6ss7iiojhlqDd2frG/gCEH0YKTP0IpgeFASw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Yf6N615X9ZB+HDp3xehMc3kjKbdsSbIJrqARRXwCRDQ=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "tests/" ]; # Not sure why it isn't autodiscovered

  pythonImportsCheck = [ "aiotarfile" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Stream-based, asynchronous tarball processing";
    homepage = "https://github.com/rhelmot/aiotarfile";
    changelog = "https://github.com/rhelmot/aiotarfile/commits/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
