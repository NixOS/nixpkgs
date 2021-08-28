{ lib, stdenv
, fetchurl
, gtk3
, meson
, ninja
, pkg-config
, gobject-introspection
, gnome
, dbus
, xvfb-run
}:

stdenv.mkDerivation rec {
  pname = "amtk";
  version = "5.3.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12v3nj1bb7507ndprjggq0hpz8k719b4bwvl8sm43p3ibmn27anm";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    dbus
    gobject-introspection
  ];

  buildInputs = [
    gtk3
  ];

  doCheck = stdenv.isLinux;
  checkPhase = ''
    export NO_AT_BRIDGE=1
    ${xvfb-run}/bin/xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = pname;
    versionPolicy = "none";
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/Amtk";
    description = "Actions, Menus and Toolbars Kit for GTK applications";
    maintainers = [ maintainers.manveru ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
