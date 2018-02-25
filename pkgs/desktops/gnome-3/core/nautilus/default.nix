{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, libxml2, desktop-file-utils, wrapGAppsHook
, gtk, gnome3, gnome-autoar, glib, dbus-glib, shared-mime-info, libnotify, libexif
, exempi, librsvg, tracker, tracker-miners, libselinux, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "nautilus-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/nautilus/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "79c99404c665ea76b3db86f261fbd28a62b54c51429b05c3314462c9de2614b4";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "nautilus"; attrPath = "gnome3.nautilus"; };
  };

  nativeBuildInputs = [ meson ninja pkgconfig libxml2 gettext wrapGAppsHook desktop-file-utils ];

  buildInputs = [ dbus-glib shared-mime-info libexif gtk exempi libnotify libselinux
                  tracker tracker-miners gnome3.gnome-desktop gnome3.adwaita-icon-theme
                  gnome3.gsettings-desktop-schemas ];

  propagatedBuildInputs = [ gnome-autoar ];

  # fatal error: gio/gunixinputstream.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

#  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  patches = [ ./extension_dir.patch ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
