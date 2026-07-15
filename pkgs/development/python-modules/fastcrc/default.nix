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
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "overcat";
    repo = "fastcrc";
    tag = "v${version}";
    hash = "sha256-13z56Ei+++UzlXs1Kmrm0qOWbr88oPMmX7mi9fK4Gbk=";
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
    hash = "sha256-Z4pMDuW0gR/by3v4/dPsanhgl09tTGe6FMJr41p9/fk=";
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
