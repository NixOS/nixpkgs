{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytest,
  pytest-asyncio,
  pytest-test-utils,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keeper_pam_webrtc_rs";
  version = "1.1.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MPtKk4n/AGBBK8ffoVP8ho9tLrOjGxUaC2XZ+kZz6q8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-KwvFm/oph2RNCDNF04UnE3NdrlC9eOCDPCN0vOICa1U=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  configurePhase = ''
    touch README.md
  '';

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-test-utils
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/"
  ];

  doCheck = false; # Tests fails with: ModuleNotFoundError: No module named 'test_utils'
  pythonImportsCheck = [ "keeper_pam_webrtc_rs" ];

  meta = {
    description = "Keeper PAM WebRTC for Python";
    homepage = "https://pypi.org/project/keeper-pam-webrtc-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gesperon ];
  };
}
