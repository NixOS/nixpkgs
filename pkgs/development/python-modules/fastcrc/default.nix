{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  pytest-benchmark,
  nix-update-script,
}:
let
  pname = "fastcrc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "overcat";
    repo = "fastcrc";
    tag = "v${version}";
    hash = "sha256-sPdkVb99rikw570H5t7rj7VPdwbbI9ywSKFQYP3Jlpg=";
  };
in
buildPythonPackage {
  inherit pname version src;
  pyproject = true;

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-beLCegktQAv72fMg7JdD8lOJ2kQW4N+fyFAMNrUGUVc=";
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
