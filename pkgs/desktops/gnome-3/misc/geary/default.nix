{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala_0_38, enchant
, wrapGAppsHook, gdk_pixbuf, cmake, desktop-file-utils
, libnotify, libcanberra-gtk3, libsecret, gmime
, libpthreadstubs, sqlite
, gnome3, librsvg, gnome-doc-utils, webkitgtk }:

let
  majorVersion = "0.12";
in
stdenv.mkDerivation rec {
  name = "geary-${majorVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/geary/${majorVersion}/${name}.tar.xz";
    sha256 = "12hbpd5j3rb122nrsqmgsg31x82xl0ksm0nmsl614v1dd7crqnh6";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [ vala_0_38 intltool pkgconfig wrapGAppsHook cmake desktop-file-utils gnome-doc-utils ];
  buildInputs = [ gtk3 enchant webkitgtk libnotify libcanberra-gtk3 gnome3.libgee libsecret gmime sqlite
                  libpthreadstubs gnome3.gsettings-desktop-schemas gnome3.gcr
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
