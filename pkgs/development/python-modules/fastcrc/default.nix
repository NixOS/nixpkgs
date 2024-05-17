{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  pytest-benchmark,
  nix-update-script,
}:
let
  pname = "fastcrc";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "overcat";
    repo = "fastcrc";
    rev = "refs/tags/v${version}";
    hash = "sha256-yLrv/zqsjgygJAIJtztwxlm4s9o9EBVsCyx1jUXd7hA=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  disabled = pythonOlder "3.7";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-wSE7548L+ymNjN9TfygAGY1BrssXOPGXlmE83wV7zb4=";
  };

  pythonImportsCheck = [ "fastcrc" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
  ];

  # Python source files interfere with testing
  preCheck = ''
    rm -r fastcrc
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hyper-fast Python module for computing CRC(8, 16, 32, 64) checksum";
    homepage = "https://fastcrc.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
