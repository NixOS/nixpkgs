{ stdenv, fetchurl, meson, ninja, vala, libxslt, pkgconfig, glib, gtk3, gnome3, python3, dconf
, libxml2, gettext, docbook_xsl, wrapGAppsHook, gobject-introspection }:

let
  pname = "dconf-editor";
  version = "3.34.2";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0pwxjada2vaf69ihpjgp9nky54iykvxq63lp1vl8pxjanif2mk6f";
  };

  nativeBuildInputs = [
    meson ninja vala libxslt pkgconfig wrapGAppsHook
    gettext docbook_xsl libxml2 gobject-introspection python3
  ];

  buildInputs = [ glib gtk3 dconf ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
