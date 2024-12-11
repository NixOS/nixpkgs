{
  fetchFromGitHub,
  lib,
  nix-update-script,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "uefi-firmware-parser";
  version = "1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theopolis";
    repo = "uefi-firmware-parser";
    rev = "v${version}";
    hash = "sha256-Yiw9idmvSpx4CcVrXHznR8vK/xl7DTL+L7k4Nvql2B8=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = [ python3.pkgs.future ];

  pythonImportsCheck = [ "uefi_firmware" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for parsing, extracting, and recreating UEFI firmware volumes";
    homepage = "https://github.com/theopolis/uefi-firmware-parser";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ KSJ2000 ];
    mainProgram = "uefi-firmware-parser";
  };
}
