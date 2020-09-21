{ stdenv
, fetchurl

, meson
, ninja
, pkgconfig
, gobject-introspection
, gsettings-desktop-schemas
, makeWrapper

, dbus
, glib
, dconf
, libX11
, libXtst # at-spi2-core can be build without X support, but due it is a client-side library, GUI-less usage is a very rare case
, libXi

, gnome3 # To pass updateScript
}:

stdenv.mkDerivation rec {
  pname = "at-spi2-core";
  version = "2.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "hONsP+ZoYhM/X+Ipdyt2qiUm4Q3lAUo3ePL6Rs5VDaU=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection makeWrapper ];
  buildInputs = [ libX11 libXtst libXi ];
  # In atspi-2.pc dbus-1 glib-2.0
  propagatedBuildInputs = [ dbus glib ];

  doCheck = false; # fails with "AT-SPI: Couldn't connect to accessibility bus. Is at-spi-bus-launcher running?"

  # Provide dbus-daemon fallback when it is not already running when
  # at-spi2-bus-launcher is executed. This allows us to avoid
  # including the entire dbus closure in libraries linked with
  # the at-spi2-core libraries.
  mesonFlags = [ "-Ddbus_daemon=/run/current-system/sw/bin/dbus-daemon" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  postFixup = ''
    # Cannot use wrapGAppsHook'due to a dependency cycle
    wrapProgram $out/libexec/at-spi-bus-launcher \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}
  '';

  meta = with stdenv.lib; {
    description = "Assistive Technology Service Provider Interface protocol definitions and daemon for D-Bus";
    homepage = "https://gitlab.gnome.org/GNOME/at-spi2-core";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
