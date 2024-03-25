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
, python3Packages
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

  budgie-clockworks = mkBudgieExtrasPlugin {
    pluginName = "clockworks";
    moduleName = "budgie_clockworks";
    isPython = true;
    pythonPath = with python3Packages; [
      cairosvg
      svgwrite
    ];
    meta.description = "Multi-clock applet to show the time across multiple timezones";
  };
}
