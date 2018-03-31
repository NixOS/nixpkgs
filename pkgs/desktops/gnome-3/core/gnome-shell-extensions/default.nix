{ stdenv, fetchurl, meson, ninja, gettext, pkgconfig, spidermonkey_52, glib, gnome3 }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "00xm5r4q40c0ji80vrsqg2fkrvzb1nm75p3ikv6bsmd3gfvwwp91";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-shell-extensions";
      attrPath = "gnome3.gnome-shell-extensions";
    };
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkgconfig gettext glib ];
  buildInputs = [ spidermonkey_52 ];

  mesonFlags = [ "-Dextension_set=all" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
