# A list of UUIDs that have the same pname and we need to rename them
# MAINTENANCE:
# - Every item from ./collisions.json (for the respective Shell version) should have an entry in here
# - Set the value to `null` for filtering (duplicate or unmaintained extensions)
# - Sort the entries in order of appearance in the collisions.json
{
  "apps-menu@gnome-shell-extensions.gcampax.github.com" = "applications-menu";
  "Applications_Menu@rmy.pobox.com" = "frippery-applications-menu";

  "workspace-indicator@gnome-shell-extensions.gcampax.github.com" = "workspace-indicator";
  "horizontal-workspace-indicator@tty2.io" = "workspace-indicator-2";

  "lockkeys@vaina.lt" = "lock-keys";
  "lockkeys@fawtytoo" = "lock-keys-2";


  # These are conflicts for 3.38 extensions. They will very probably come back
  # once more of them support 40.

  # See https://github.com/pbxqdown/gnome-shell-extension-transparent-window/issues/12#issuecomment-800765381
  #"transparent-window@pbxqdown.github.com" = "transparent-window";
  #"transparentwindows.mdirshad07" = null;

  #"floatingDock@sun.wxg@gmail.com" = "floating-dock";
  #"floating-dock@nandoferreira_prof@hotmail.com" = "floating-dock-2";

  # That extension is broken because of https://github.com/NixOS/nixpkgs/issues/118612
  #"flypie@schneegans.github.com" = null;
}
