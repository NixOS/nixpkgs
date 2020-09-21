{ stdenv
, fetchurl
, gtk3
, pkgconfig
, gobject-introspection
, gnome3
, dbus
, xvfb_run
}:

stdenv.mkDerivation rec {
  pname = "amtk";
  version = "5.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1wax6mim8dj0m21k8ima7ysm3bzzp54r00jganwbzakq8bfnnrgr";
  };

  nativeBuildInputs = [
    pkgconfig
    dbus
    gobject-introspection
  ];

  buildInputs = [
    gtk3
  ];

  doCheck = stdenv.isLinux;
  checkPhase = ''
    export NO_AT_BRIDGE=1
    ${xvfb_run}/bin/xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Projects/Amtk";
    description = "Actions, Menus and Toolbars Kit for GTK applications";
    maintainers = [ maintainers.manveru ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
