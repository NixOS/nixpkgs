{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala, makeWrapper
, gnome3, glib, libsoup, libgdata, sqlite, itstool, xdg_utils }:

let
  majorVersion = "0.4";
in
stdenv.mkDerivation rec {
  name = "california-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/california/${majorVersion}/${name}.tar.xz";
    sha256 = "1dky2kllv469k8966ilnf4xrr7z35pq8mdvs7kwziy59cdikapxj";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ makeWrapper intltool pkgconfig vala glib gtk3 gnome3.libgee
    libsoup libgdata gnome3.gnome_online_accounts gnome3.evolution_data_server
    sqlite itstool xdg_utils gnome3.gsettings_desktop_schemas ];

  preFixup = ''
    wrapProgram "$out/bin/california" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gnome3.defaultIconTheme}/share:${gnome3.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH:${gnome3.gsettings_desktop_schemas}/share"
  '';

  enableParallelBuilding = true;

  # Apply fedoras patch to build with evolution-data-server >3.13
  patches = [ ./0002-Build-with-evolution-data-server-3.13.90.patch ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/California;
    description = "Calendar application for GNOME 3";
    maintainers = with maintainers; [ pSub ];
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
