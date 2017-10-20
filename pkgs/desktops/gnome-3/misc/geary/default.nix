{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala_0_38, enchant
, wrapGAppsHook, gdk_pixbuf, cmake, desktop_file_utils
, libnotify, libcanberra_gtk3, libsecret, gmime
, libpthreadstubs, sqlite
, gnome3, librsvg, gnome_doc_utils, webkitgtk }:

let
  majorVersion = "0.12";
in
stdenv.mkDerivation rec {
  name = "geary-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/geary/${majorVersion}/${name}.tar.xz";
    sha256 = "0ii4qaqfqx90kvqwg0g9jahygkir4mb03ja55fa55yyx6cq0kwff";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ vala_0_38 intltool pkgconfig wrapGAppsHook cmake desktop_file_utils gnome_doc_utils ];
  buildInputs = [ gtk3 enchant webkitgtk libnotify libcanberra_gtk3 gnome3.libgee libsecret gmime sqlite
                  libpthreadstubs gnome3.gsettings_desktop_schemas gnome3.gcr
                  gdk_pixbuf librsvg gnome3.defaultIconTheme ];

  preConfigure = ''
    substituteInPlace src/CMakeLists.txt --replace '`''${PKG_CONFIG_EXECUTABLE} --variable=girdir gobject-introspection-1.0`' '${webkitgtk.dev}/share/gir-1.0'
  '';

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Geary;
    description = "Mail client for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
