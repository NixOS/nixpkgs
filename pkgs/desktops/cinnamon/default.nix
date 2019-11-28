{ newScope }:

let
  callPackage = newScope self;

  self = rec {

    cinnamon-common = callPackage ./cinnamon-common { };
    cinnamon-control-center = callPackage ./cinnamon-control-center { };
    cinnamon-desktop = callPackage ./cinnamon-desktop { };
    cinnamon-translations = callPackage ./cinnamon-translations { };
    cinnamon-menus = callPackage ./cinnamon-menus { };
    cinnamon-session = callPackage ./cinnamon-session { };
    cinnamon-settings-daemon = callPackage ./cinnamon-settings-daemon { };
    cinnamon-screensaver = callPackage ./cinnamon-screensaver { };
    cjs = callPackage ./cjs { };
    muffin = callPackage ./muffin { };
    nemo = callPackage ./nemo { };
    xapps = callPackage ./xapps { };

    # basePackages = [
    #
    #];

    #extraPackages = [
    #
    #];

  };

in self
