{ callPackage
, appstream
, budgie
, gnome
, gnome-menus
, gtk3
, json-glib
, libgee
, libhandy
, libpeas
, pantheon
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

  budgie-applications-menu = mkBudgieExtrasPlugin {
    pluginName = "applications-menu";
    buildInputs = [
      appstream
      budgie.budgie-desktop
      gtk3
      json-glib
      libgee
      libhandy
      libpeas
      pantheon.granite
    ];
    meta.description = "Application launcher for Budgie";
  };

  budgie-brightness-controller = mkBudgieExtrasPlugin {
    pluginName = "brightness-controller";
    buildInputs = [
      budgie.budgie-desktop
      gnome.gnome-settings-daemon
      gtk3
      libpeas
    ];
    meta.description = "Brightness controller for Budgie";
  };
}
