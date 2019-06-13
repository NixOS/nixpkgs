{ mkXfceDerivation, exo, wrapGAppsHook, dbus-glib, gtk3, gtksourceview3 }:

mkXfceDerivation rec {
  category = "apps";
  pname = "mousepad";
  version = "0.4.1";

  sha256 = "0pr1w9n0qq2raxhy78982i9g17x0ya02q7vdrn0wb2bpk74hlki5";

  nativeBuildInputs = [ exo wrapGAppsHook ];
  buildInputs = [ dbus-glib gtk3 gtksourceview3 ];
}
