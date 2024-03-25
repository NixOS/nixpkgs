{ callPackage
, appstream
, budgie
, gnome
, gnome-menus
, gtk3
, json-glib
, libgee
, libhandy
, libnotify
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

  budgie-countdown = mkBudgieExtrasPlugin {
    pluginName = "countdown";
    moduleName = "budgie-countdown";
    isPython = true;
    meta.description = "Count down applet with options";
  };

  budgie-dropby = mkBudgieExtrasPlugin {
    pluginName = "dropby";
    moduleName = "budgie_dropby";
    isPython = true;
    pythonPath = with python3Packages; [
      psutil
      pyudev
    ];
    meta.description = "Popup menu for USB drives";
  };

  budgie-fuzzyclock = mkBudgieExtrasPlugin {
    pluginName = "fuzzyclock";
    buildInputs = [
      budgie.budgie-desktop
      gtk3
      libpeas
    ];
    meta.description = "Time of day in fuzzy way";
  };

  budgie-hotcorners = mkBudgieExtrasPlugin {
    pluginName = "hotcorners";
    buildInputs = [
      budgie.budgie-desktop
      gtk3
      json-glib
      libnotify
      libpeas
    ];
    postPatch = ''
      patchShebangs budgie-hotcorners/applet/meson_post_install.py
    '';
    meta.description = "Set hotcorner actions";
  };
}
