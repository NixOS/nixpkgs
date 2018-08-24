{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, vte, libxml2, gtk-vnc, intltool
, libsecret, itstool, wrapGAppsHook, librsvg }:

stdenv.mkDerivation rec {
  name = "vinagre-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vinagre/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "cd1cdbacca25c8d1debf847455155ee798c3e67a20903df8b228d4ece5505e82";
  };

  nativeBuildInputs = [ pkgconfig intltool itstool wrapGAppsHook ];
  buildInputs = [
    gtk3 vte libxml2 gtk-vnc libsecret gnome3.defaultIconTheme librsvg
  ];

  NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "vinagre";
      attrPath = "gnome3.vinagre";
    };
  };

  meta = with stdenv.lib; {
    description = "Remote desktop viewer for GNOME";
    homepage = https://wiki.gnome.org/Apps/Vinagre;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
