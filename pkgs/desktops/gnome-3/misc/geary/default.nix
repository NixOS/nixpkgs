{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala_0_40, enchant
, wrapGAppsHook, gdk_pixbuf, cmake, ninja, desktop-file-utils
, libnotify, libcanberra-gtk3, libsecret, gmime, isocodes
, gobjectIntrospection, libpthreadstubs, sqlite
, gnome3, librsvg, gnome-doc-utils, webkitgtk }:

let
  pname = "geary";
  version = "0.12.1";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "12hbpd5j3rb122nrsqmgsg31x82xl0ksm0nmsl614v1dd7crqnh6";
  };

  nativeBuildInputs = [ vala_0_40 intltool pkgconfig wrapGAppsHook cmake ninja desktop-file-utils gnome-doc-utils gobjectIntrospection ];
  buildInputs = [
    gtk3 enchant webkitgtk libnotify libcanberra-gtk3 gnome3.libgee libsecret gmime sqlite
    libpthreadstubs gnome3.gsettings-desktop-schemas gnome3.gcr isocodes
    gdk_pixbuf librsvg gnome3.defaultIconTheme
  ];

  cmakeFlags = [
    "-DISOCODES_DIRECTORY=${isocodes}/share/xml/iso-codes"
  ];

  # TODO: This is bad, upstream should fix their code.
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${webkitgtk.dev}/share/gir-1.0";

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Geary;
    description = "Mail client for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
