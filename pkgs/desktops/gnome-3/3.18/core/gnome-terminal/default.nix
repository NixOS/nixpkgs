{ stdenv, fetchurl, pkgconfig, cairo, libxml2, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, libuuid, vala
, desktop_file_utils, itstool, makeWrapper, appdata-tools }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ gnome3.gtk gnome3.gsettings_desktop_schemas gnome3.vte appdata-tools
                  gnome3.dconf itstool makeWrapper gnome3.nautilus vala ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which libuuid libxml2 desktop_file_utils ];

  # Silly ./configure, it looks for dbus file from gnome-shell in the
  # installation tree of the package it is configuring.
  preConfigure = ''
    mkdir -p "$out/share/dbus-1/interfaces"
    cp "${gnome3.gnome_shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml" "$out/share/dbus-1/interfaces"
  '';

  # FIXME: enable for gnome3
  configureFlags = [ "--disable-migration" ];

  preFixup = ''
    for f in "$out/libexec/gnome-terminal-server"; do
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH" \
        --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
