{
  lib,
  callPackage,
  stdenvNoCC,
  writeShellScript,
}:
let
  root = ./.;
  updateScript = ./update.py;

  mkYaziFlavor = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;

    extendDrvArgs =
      finalAttrs:
      {
        pname,
        src,
        meta ? { },
        installPhase ? null,
        ...
      }@args:
      let
        # Extract the flavor name from pname (removing .yazi suffix if present)
        flavorName = lib.removeSuffix ".yazi" pname;
      in
      {
        installPhase =
          if installPhase != null then
            installPhase
          else
            # Normal flavors don't require special installation other than to copy their contents.
            ''
              runHook preInstall

              cp -r . $out

              runHook postInstall
            '';
        meta = meta // {
          description = meta.description or "";
          platforms = meta.platforms or lib.platforms.all;
          homepage =
            if (src ? owner && src.owner == "yazi-rs") then
              "https://github.com/yazi-rs/flavors/tree/main/${pname}"
            else
              meta.homepage or null;
        };
        passthru = (args.passthru or { }) // {
          updateScript = {
            command = writeShellScript "update-${flavorName}" ''
              export FLAVOR_NAME="${flavorName}"
              export FLAVOR_PNAME="${pname}"
              exec ${updateScript}
            '';
            supportedFeatures = [ "commit" ];
          };
        };
      };
  };

  call = name: callPackage (root + "/${name}") { inherit mkYaziFlavor; };
in
lib.pipe root [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: _: call name))
]
// {
  inherit mkYaziFlavor;
}
