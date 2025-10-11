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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "overcat";
    repo = "fastcrc";
    tag = "v${version}";
    hash = "sha256-NE2ZrrpVBxCb5xuRihdGYHctD1lUp9VUGaeOalwf4pQ=";
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

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-mImDrbPliz0LcmDSxQxNpTkCYIEFw2bzt2fHhQr27+0=";
  };

  pythonImportsCheck = [ "fastcrc" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
  ];

  pytestFlags = [ "--benchmark-disable" ];

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
