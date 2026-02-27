{
  fetchFromGitHub,
  lib,
  nix-update-script,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "uefi-firmware-parser";
  version = "1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theopolis";
    repo = "uefi-firmware-parser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JPNur7Ipi+Ite9B7lqDm7h7iYUga8D+l18J2knCWZpk=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonRemoveDeps = [ "future" ];

  pythonImportsCheck = [ "uefi_firmware" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for parsing, extracting, and recreating UEFI firmware volumes";
    homepage = "https://github.com/theopolis/uefi-firmware-parser";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "uefi-firmware-parser";
  };
})
