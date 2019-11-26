{ newScope }:

let
  callPackage = newScope self;

  self = rec {

    cinnamon = callPackage ./cinnamon { };
    cinnamon-desktop = callPackage ./cinnamon-desktop { };
    cinnamon-menus = callPackage ./cinnamon-menus { };
    cinnamon-session = callPackage ./cinnamon-session { gconf = self.gnome2.GConf; };
    cinnamon-settings-daemon = callPackage ./cinnamon-settings-daemon { };
    cjs = callPackage ./cjs { };
    muffin = callPackage ./muffin { };
    xapps = callPackage ./xapps { };

    # basePackages = [
    #
    #];

    #extraPackages = [
    #
    #];

  };

in self
