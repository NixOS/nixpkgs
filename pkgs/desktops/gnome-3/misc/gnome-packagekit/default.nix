{ stdenv, fetchurl, pkgconfig, meson, ninja, gettext, gnome3, libxslt, packagekit, polkit
, fontconfig, libcanberra-gtk3, systemd, libnotify, wrapGAppsHook, dbus-glib, dbus_libs, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-packagekit-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-packagekit/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "6a219e16923d3976f424416c944bef06913922da24bc9e6644ec114c2d563417";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-packagekit"; attrPath = "gnome3.gnome-packagekit"; };
  };

  NIX_CFLAGS_COMPILE = "-I${dbus-glib.dev}/include/dbus-1.0 -I${dbus_libs.dev}/include/dbus-1.0";

  nativeBuildInputs = [ pkgconfig meson ninja gettext wrapGAppsHook desktop-file-utils ];
  buildInputs = [ libxslt gnome3.gtk packagekit fontconfig systemd polkit
                  libcanberra-gtk3 libnotify dbus-glib dbus_libs ];

  prePatch = "patchShebangs meson_post_install.sh";

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/software/PackageKit/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    description = "Tools for installing software on the GNOME desktop using PackageKit";
  };
}
