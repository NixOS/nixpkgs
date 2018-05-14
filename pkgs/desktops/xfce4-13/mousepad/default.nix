{ mkXfceDerivation, exo, wrapGAppsHook, dbus_glib ? null, gtk3, gtksourceview }:

mkXfceDerivation rec {
  category = "apps";
  pname = "mousepad";
  version = "0.4.0";

  sha256 = "0mm90iq2yd3d0qbgsjyk3yj25k0gm3p34jazl640vixk84v20lyw";

  nativeBuildInputs = [ exo wrapGAppsHook ];
  buildInputs = [ dbus_glib gtk3 gtksourceview ];
}
