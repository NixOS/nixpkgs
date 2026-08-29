{
  lib,
  makeSetupHook,
  buildPackages,
}:

makeSetupHook {
  name = "verify-desktop-items-hook";
  substitutions = {
    crudini = lib.getExe buildPackages.crudini;
    desktopFileValidate = lib.getExe' buildPackages.desktop-file-utils "desktop-file-validate";
    standardIconNames = ./standard-icon-names.txt;
  };

  meta = {
    description = "Verify that installed desktop items reference an existing executable and icon";
    maintainers = with lib.maintainers; [ h7x4 ];
    license = lib.licenses.mit;
  };
} ./hook.sh
