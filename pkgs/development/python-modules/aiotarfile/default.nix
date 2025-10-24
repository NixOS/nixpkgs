{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  unittestCheckHook,
  cargo,
  rustc,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "aiotarfile";
  version = "0.5.2";
  pyproject = true;

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

  meta = {
    description = "Stream-based, asynchronous tarball processing";
    homepage = "https://github.com/rhelmot/aiotarfile";
    changelog = "https://github.com/rhelmot/aiotarfile/commits/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
