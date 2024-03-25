{ callPackage
, gnome-menus
}:

let
  mkBudgieExtrasPlugin = callPackage ./mkBudgieExtrasPlugin.nix { };
in

{
  inherit mkBudgieExtrasPlugin;

  budgie-app-launcher = mkBudgieExtrasPlugin {
    pluginName = "app-launcher";
    moduleName = "AppLauncher";
    isPython = true;
    buildInputs = [
      gnome-menus
    ];
    meta.description = "This applet lists your favourite apps";
  };
}
