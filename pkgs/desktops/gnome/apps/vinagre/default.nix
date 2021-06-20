{ lib, stdenv, fetchurl, pkg-config, gtk3, gnome, vte, libxml2, gtk-vnc, intltool
, libsecret, itstool, wrapGAppsHook, librsvg }:

stdenv.mkDerivation rec {
  pname = "vinagre";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vinagre/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "cd1cdbacca25c8d1debf847455155ee798c3e67a20903df8b228d4ece5505e82";
  };

  nativeBuildInputs = [ pkg-config intltool itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 vte libxml2 gtk-vnc libsecret gnome.adwaita-icon-theme librsvg
  ];

  NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "vinagre";
      attrPath = "gnome.vinagre";
    };
  };

  meta = with lib; {
    description = "Remote desktop viewer for GNOME";
    homepage = "https://wiki.gnome.org/Apps/Vinagre";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
