{ fetchurl, stdenv, pkgconfig, glib, gnome3, nspr, intltool, gobject-introspection
, vala, sqlite, libxml2, dbus-glib, libsoup, nss, dbus
, telepathy-glib, evolution-data-server, libsecret, db }:

# TODO: enable more folks backends

let
  version = "0.11.4";
in stdenv.mkDerivation rec {
  name = "folks-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/folks/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "16hqh2gxlbx0b0hgq216hndr1m72vj54jvryzii9zqkk0g9kxc57";
  };

  propagatedBuildInputs = [ glib gnome3.libgee sqlite ];
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
      packageName = "folks";
      attrPath = "gnome3.folks";
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Folks";

    homepage = https://wiki.gnome.org/Projects/Folks;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = gnome3.maintainers;
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
