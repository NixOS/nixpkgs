{
  python3Packages,
}:
let
  inherit (python3Packages)
    toPythonApplication
    uefi-firmware-parser
    ;
in
toPythonApplication uefi-firmware-parser
