{ stdenv, gettext, libxml2, fetchurl, pkgconfig, libcanberra_gtk3
, bash, gtk3, glib, meson, ninja, wrapGAppsHook, appstream-glib
, gnome3, librsvg, gdk_pixbuf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  checkPhase = "meson test";


  postPatch = ''
    chmod +x build-aux/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/postinstall.py
  '';

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];
  propagatedBuildInputs = [ gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext appstream-glib libxml2 wrapGAppsHook ];
  buildInputs = [ bash gtk3 glib libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas ];

  patches = [
    ./prevent-cache-updates.patch
  ];

  meta = with stdenv.lib; {
    homepage = https://en.wikipedia.org/wiki/GNOME_Screenshot;
    description = "Utility used in the GNOME desktop environment for taking screenshots";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
