self: super:

{
  cinnamon = super.callPackage ./cinnamon { };
  cinnamon-desktop = super.callPackage ./cinnamon-desktop { };
  cinnamon-menus = super.callPackage ./cinnamon-menus { };
  cinnamon-session = super.callPackage ./cinnamon-session { gconf = super.gnome2.GConf; };
  cinnamon-settings-daemon = super.callPackage ./cinnamon-settings-daemon { };
  cjs = super.callPackage ./cjs { };
  muffin = super.callPackage ./muffin { };
  xapps = super.callPackage ./xapps { };
}
