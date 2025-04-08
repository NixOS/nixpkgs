{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  root = ./.;

  mkYaziPlugin =
    args@{
      pname,
      src,
      meta ? { },
      installPhase ? null,
      ...
    }:
    stdenvNoCC.mkDerivation (
      args
      // {
        installPhase =
          if installPhase != null then
            installPhase
          else if (src ? owner && src.owner == "yazi-rs") then
            # NOTE: License is a relative symbolic link
            # We remove the link and copy the true license
            ''
              runHook preInstall

              cp -r ${pname} $out
              rm $out/LICENSE
              cp LICENSE $out

              runHook postInstall
            ''
          else
            # Normal plugins don't require special installation other than to copy their contents.
            ''
              runHook preInstall

              cp -r . $out

              runHook postInstall
            '';
        meta = meta // {
          description = meta.description or "";
          platforms = meta.platforms or lib.platforms.all;
        };
      }
    );

  call = name: callPackage (root + "/${name}") { inherit mkYaziPlugin; };
in
lib.pipe root [
  builtins.readDir
  (lib.filterAttrs (_: type: type == "directory"))
  (builtins.mapAttrs (name: _: call name))
]
// {
  inherit mkYaziPlugin;
}
