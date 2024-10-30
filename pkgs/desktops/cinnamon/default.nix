{ config, pkgs, lib }:

# The cinnamon scope is deprecated and no package additions should be done here.
#
# TODO (after 24.11 branch-off): Remove this scope entirely.
# TODO (after 25.05 branch-off): Rename pkgs.cinnamon-common to pkgs.cinnamon.

lib.makeScope pkgs.newScope (self: { }) // lib.optionalAttrs config.allowAliases {
  # Aliases need to be outside the scope or they will shadow the attributes from parent scope.
  bulky = lib.warn "cinnamon.bulky was moved to top-level. Please use pkgs.bulky directly." pkgs.bulky; # Added on 2024-07-14
  cinnamon-common = lib.warn "cinnamon.cinnamon-common was moved to top-level. Please use pkgs.cinnamon-common directly." pkgs.cinnamon-common; # Added on 2024-07-22
  cinnamon-control-center = lib.warn "cinnamon.cinnamon-control-center was moved to top-level. Please use pkgs.cinnamon-control-center directly." pkgs.cinnamon-control-center; # Added on 2024-07-22
  cinnamon-desktop = lib.warn "cinnamon.cinnamon-desktop was moved to top-level. Please use pkgs.cinnamon-desktop directly." pkgs.cinnamon-desktop; # Added on 2024-07-22
  cinnamon-gsettings-overrides = lib.warn "cinnamon.cinnamon-gsettings-overrides was moved to top-level. Please use pkgs.cinnamon-gsettings-overrides directly." pkgs.cinnamon-gsettings-overrides; # Added on 2024-07-22
  cinnamon-menus = lib.warn "cinnamon.cinnamon-menus was moved to top-level. Please use pkgs.cinnamon-menus directly." pkgs.cinnamon-menus; # Added on 2024-07-22
  cinnamon-screensaver = lib.warn "cinnamon.cinnamon-screensaver was moved to top-level. Please use pkgs.cinnamon-screensaver directly." pkgs.cinnamon-screensaver; # Added on 2024-07-22
  cinnamon-session = lib.warn "cinnamon.cinnamon-session was moved to top-level. Please use pkgs.cinnamon-session directly." pkgs.cinnamon-session; # Added on 2024-07-22
  cinnamon-settings-daemon = lib.warn "cinnamon.cinnamon-settings-daemon was moved to top-level. Please use pkgs.cinnamon-settings-daemon directly." pkgs.cinnamon-settings-daemon; # Added on 2024-07-22
  cinnamon-translations = lib.warn "cinnamon.cinnamon-translations was moved to top-level. Please use pkgs.cinnamon-translations directly." pkgs.cinnamon-translations; # Added on 2024-07-22
  cjs = lib.warn "cinnamon.cjs was moved to top-level. Please use pkgs.cjs directly." pkgs.cjs; # Added on 2024-07-22
  iso-flags-png-320x420 = lib.warn "cinnamon.iso-flags-png-320x420 was moved to top-level and renamed to pkgs.iso-flags-png-320x240." pkgs.iso-flags-png-320x240; # Added on 2024-07-14
  iso-flags-svg = throw "cinnamon.iso-flags-svg was removed because this is not used in Cinnamon. You can directly obtain the images from \"\${pkgs.iso-flags.src}/svg\"."; # Added on 2024-07-14
  folder-color-switcher = lib.warn "cinnamon.folder-color-switcher was moved to top-level. Please use pkgs.folder-color-switcher directly." pkgs.folder-color-switcher; # Added on 2024-07-14
  mint-artwork = lib.warn "cinnamon.mint-artwork was moved to top-level. Please use pkgs.mint-artwork directly." pkgs.mint-artwork; # Added on 2024-07-14
  mint-cursor-themes = lib.warn "cinnamon.mint-cursor-themes was moved to top-level. Please use pkgs.mint-cursor-themes directly." pkgs.mint-cursor-themes; # Added on 2024-07-14
  mint-l-icons = lib.warn "cinnamon.mint-l-icons was moved to top-level. Please use pkgs.mint-l-icons directly." pkgs.mint-l-icons; # Added on 2024-07-14
  mint-l-theme = lib.warn "cinnamon.mint-l-theme was moved to top-level. Please use pkgs.mint-l-theme directly." pkgs.mint-l-theme; # Added on 2024-07-14
  mint-themes = lib.warn "cinnamon.mint-themes was moved to top-level. Please use pkgs.mint-themes directly." pkgs.mint-themes; # Added on 2024-07-14
  mint-x-icons = lib.warn "cinnamon.mint-x-icons was moved to top-level. Please use pkgs.mint-x-icons directly." pkgs.mint-x-icons; # Added on 2024-07-14
  mint-y-icons = lib.warn "cinnamon.mint-y-icons was moved to top-level. Please use pkgs.mint-y-icons directly." pkgs.mint-y-icons; # Added on 2024-07-14
  muffin = lib.warn "cinnamon.muffin was moved to top-level. Please use pkgs.muffin directly." pkgs.muffin; # Added on 2024-07-22
  nemo = lib.warn "cinnamon.nemo was moved to top-level. Please use pkgs.nemo directly." pkgs.nemo; # Added on 2024-07-22
  nemo-emblems = lib.warn "cinnamon.nemo-emblems was moved to top-level. Please use pkgs.nemo-emblems directly." pkgs.nemo-emblems; # Added on 2024-07-22
  nemo-fileroller = lib.warn "cinnamon.nemo-fileroller was moved to top-level. Please use pkgs.nemo-fileroller directly." pkgs.nemo-fileroller; # Added on 2024-07-22
  nemo-python = lib.warn "cinnamon.nemo-python was moved to top-level. Please use pkgs.nemo-python directly." pkgs.nemo-python; # Added on 2024-07-22
  nemo-with-extensions = lib.warn "cinnamon.nemo-with-extensions was moved to top-level. Please use pkgs.nemo-with-extensions directly." pkgs.nemo-with-extensions; # Added on 2024-07-22
  nemoExtensions = throw "cinnamon.nemoExtensions is no longer exposed. To modify list of selected nemo extensions please override pkgs.nemo-with-extensions."; # Added on 2024-07-14
  pix = lib.warn "cinnamon.pix was moved to top-level. Please use pkgs.pix directly." pkgs.pix; # Added on 2024-07-14
  warpinator = lib.warn "cinnamon.warpinator was moved to top-level. Please use pkgs.warpinator directly." pkgs.warpinator; # Added on 2024-07-14
  xapp = lib.warn "cinnamon.xapp was moved to top-level. Please use pkgs.xapp directly." pkgs.xapp; # Added on 2024-07-14
  xapps = lib.warn "cinnamon.xapps was moved to top-level and renamed to pkgs.xapp." pkgs.xapp; # Added 2022-07-27
  xreader = lib.warn "cinnamon.xreader was moved to top-level. Please use pkgs.xreader directly." pkgs.xreader; # Added on 2024-07-14
  xviewer = lib.warn "cinnamon.xviewer was moved to top-level. Please use pkgs.xviewer directly." pkgs.xviewer; # Added on 2024-07-14
}
