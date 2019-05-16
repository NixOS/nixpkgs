{ stdenv, fetchurl, meson, ninja, gettext, python3, pkgconfig, gnome3, gtk3
, gobject-introspection, gdk_pixbuf, librsvg, libgweather
, geoclue2, wrapGAppsHook, folks, libchamplain, gfbgraph, libsoup, gsettings-desktop-schemas
, webkitgtk, gjs, libgee, geocode-glib, evolution-data-server, gnome-online-accounts }:

let
  pname = "gnome-maps";
  version = "3.32.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1q15qsp0ca67y4l0x31518cfakrj85x9g0cbcm0wysnbddi1aik0";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkgconfig gettext python3 wrapGAppsHook ];
  buildInputs = [
    gobject-introspection
    gtk3 geoclue2 gjs libgee folks gfbgraph
    geocode-glib libchamplain libsoup
    gdk_pixbuf librsvg libgweather
    gsettings-desktop-schemas evolution-data-server
    gnome-online-accounts gnome3.adwaita-icon-theme
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

    # The .service file isn't wrapped with the correct environment
    # so misses GIR files when started. By re-pointing from the gjs
    # entry point to the wrapped binary we get back to a wrapped
    # binary.
    substituteInPlace "data/org.gnome.Maps.service.in" \
        --replace "Exec=@pkgdatadir@/org.gnome.Maps" \
                  "Exec=$out/bin/gnome-maps"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Maps;
    description = "A map application for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
