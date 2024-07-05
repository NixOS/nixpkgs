{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, buildPackages
, withIntrospection ? lib.meta.availableOn stdenv.hostPlatform gobject-introspection && stdenv.hostPlatform.emulatorAvailable buildPackages
, gsettings-desktop-schemas
, makeWrapper
, dbus
, glib
, dconf
, libX11
, libxml2
, libXtst
, libXi
, libXext
, gnome
, systemd
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd
}:

stdenv.mkDerivation rec {
  pname = "at-spi2-core";
  version = "2.52.0";

  outputs = [ "out" "dev" ];
  separateDebugInfo = true;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-CsP8gyDI0B+hR8Jyun+gOAY4nGsD08QG0II+MONf9as=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    makeWrapper
  ] ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    libX11
    libxml2
    # at-spi2-core can be build without X support, but due it is a client-side library, GUI-less usage is a very rare case
    libXtst
    libXi
    # libXext is a transitive dependency of libXi
    libXext
  ] ++ lib.optionals systemdSupport [
    # libsystemd is a needed for dbus-broker support
    systemd
  ];

  # In atspi-2.pc dbus-1 glib-2.0
  # In atk.pc gobject-2.0
  propagatedBuildInputs = [
    dbus
    glib
  ];

  # fails with "AT-SPI: Couldn't connect to accessibility bus. Is at-spi-bus-launcher running?"
  doCheck = false;

  mesonFlags = [
    # Provide dbus-daemon fallback when it is not already running when
    # at-spi2-bus-launcher is executed. This allows us to avoid
    # including the entire dbus closure in libraries linked with
    # the at-spi2-core libraries.
    "-Ddbus_daemon=/run/current-system/sw/bin/dbus-daemon"
  ] ++ lib.optionals systemdSupport [
    # Same as the above, but for dbus-broker
    "-Ddbus_broker=/run/current-system/sw/bin/dbus-broker-launch"
  ] ++ lib.optionals (!systemdSupport) [
    "-Duse_systemd=false"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  postFixup = ''
    # Cannot use wrapGAppsHook'due to a dependency cycle
    wrapProgram $out/libexec/at-spi-bus-launcher \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}
  '';

  meta = with lib; {
    description = "Assistive Technology Service Provider Interface protocol definitions and daemon for D-Bus";
    homepage = "https://gitlab.gnome.org/GNOME/at-spi2-core";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ raskin ]);
    platforms = platforms.unix;
  };
}
