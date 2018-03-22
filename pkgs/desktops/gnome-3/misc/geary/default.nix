{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala_0_40, enchant
, wrapGAppsHook, gdk_pixbuf, cmake, ninja, desktop-file-utils
, libnotify, libcanberra-gtk3, libsecret, gmime, isocodes
, gobjectIntrospection, libpthreadstubs, sqlite
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

  nativeBuildInputs = [ vala_0_40 intltool pkgconfig wrapGAppsHook cmake ninja desktop-file-utils gnome-doc-utils gobjectIntrospection ];
  buildInputs = [
    gtk3 enchant webkitgtk libnotify libcanberra-gtk3 gnome3.libgee libsecret gmime sqlite
    libpthreadstubs gnome3.gsettings-desktop-schemas gnome3.gcr isocodes
    gdk_pixbuf librsvg gnome3.defaultIconTheme
  ];

  cmakeFlags = [
    "-DISOCODES_DIRECTORY=${isocodes}/share/xml/iso-codes"
  ];

  preConfigure = ''
    substituteInPlace src/CMakeLists.txt --replace '`''${PKG_CONFIG_EXECUTABLE} --variable=girdir gobject-introspection-1.0`' '${webkitgtk.dev}/share/gir-1.0'
  '';

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Geary;
    description = "Mail client for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
