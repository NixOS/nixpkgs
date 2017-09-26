{ stdenv, fetchurl, pkgconfig, cairo, libxml2, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, libuuid, vala_0_32
, desktop_file_utils, itstool, wrapGAppsHook, appdata-tools }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ gnome3.gtk gnome3.gsettings_desktop_schemas gnome3.vte appdata-tools
                  gnome3.dconf itstool gnome3.nautilus vala_0_32 ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which libuuid libxml2
                        desktop_file_utils wrapGAppsHook ];

  # Silly ./configure, it looks for dbus file from gnome-shell in the
  # installation tree of the package it is configuring.
  postPatch = ''
    substituteInPlace configure --replace '$(eval echo $(eval echo $(eval echo ''${dbusinterfacedir})))/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome_shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
    substituteInPlace src/Makefile.in --replace '$(dbusinterfacedir)/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome_shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
  '';

  # FIXME: enable for gnome3
  configureFlags = [ "--disable-migration" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The GNOME Terminal Emulator";
    homepage = https://wiki.gnome.org/Apps/Terminal/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
