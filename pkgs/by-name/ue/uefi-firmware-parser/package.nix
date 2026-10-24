{ python3Packages }:

# The Python distribution is `uefi_firmware`, but the project and its binary are
# `uefi-firmware-parser`, so the application keeps that name.
(python3Packages.toPythonApplication python3Packages.uefi-firmware).overrideAttrs {
  pname = "uefi-firmware-parser";
}
