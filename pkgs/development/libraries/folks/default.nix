{ fetchurl, stdenv, pkgconfig, glib, gnome3, nspr, intltool, gobject-introspection
, vala, sqlite, libxml2, dbus-glib, libsoup, nss, dbus, libgee
, telepathy-glib, evolution-data-server, libsecret, db }:

# TODO: enable more folks backends

stdenv.mkDerivation rec {
  pname = "folks";
  version = "0.11.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "16hqh2gxlbx0b0hgq216hndr1m72vj54jvryzii9zqkk0g9kxc57";
  };

  propagatedBuildInputs = [ glib libgee sqlite ];
  # dbus_daemon needed for tests
  buildInputs = [
    dbus-glib telepathy-glib evolution-data-server dbus
    libsecret libxml2 libsoup nspr nss db
  ];
  nativeBuildInputs = [ pkgconfig intltool vala gobject-introspection ];

  configureFlags = [ "--disable-fatal-warnings" ];

  NIX_CFLAGS_COMPILE = ["-I${nss.dev}/include/nss"
                        "-I${dbus-glib.dev}/include/dbus-1.0" "-I${dbus.dev}/include/dbus-1.0"];

  enableParallelBuilding = true;

  postBuild = "rm -rf $out/share/gtk-doc";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = {
    description = "A library that aggregates people from multiple sources to create metacontacts";
    homepage = https://wiki.gnome.org/Projects/Folks;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
