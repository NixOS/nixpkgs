{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2, desktop-file-utils, python3, wrapGAppsHook
, gtk, gnome3, gnome-autoar, dbus-glib, shared-mime-info, libnotify, libexif
, exempi, librsvg, tracker, tracker-miners, gnome-desktop, gexiv2, libselinux, gdk_pixbuf }:

let
  pname = "nautilus";
  version = "3.28.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "19dhpa2ylrg8d5274lahy7xqr2p9z3jnq1h4qmsh95czkpy7is4w";
  };

  nativeBuildInputs = [ meson ninja pkgconfig libxml2 gettext python3 wrapGAppsHook desktop-file-utils ];

  buildInputs = [
    dbus-glib shared-mime-info libexif gtk exempi libnotify libselinux
    tracker tracker-miners gnome-desktop gexiv2
    gnome3.adwaita-icon-theme gnome3.gsettings-desktop-schemas
  ];

  propagatedBuildInputs = [ gnome-autoar ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  patches = [ ./extension_dir.patch ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "The file manager for GNOME";
    homepage = https://wiki.gnome.org/Apps/Files;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
