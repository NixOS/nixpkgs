{ fetchurl, stdenv, pkgconfig, glib, gnome3, nspr, intltool
, vala, sqlite, libxml2, dbus-glib, libsoup, nss, dbus_libs
, telepathy-glib, evolution-data-server, libsecret, db }:

# TODO: enable more folks backends

let
  majorVersion = "0.11";
in
stdenv.mkDerivation rec {
  name = "folks-${majorVersion}.4";

  src = fetchurl {
    url = "mirror://gnome/sources/folks/${majorVersion}/${name}.tar.xz";
    sha256 = "16hqh2gxlbx0b0hgq216hndr1m72vj54jvryzii9zqkk0g9kxc57";
  };

  propagatedBuildInputs = [ glib gnome3.libgee sqlite ];
  # dbus_daemon needed for tests
  buildInputs = [ dbus-glib telepathy-glib evolution-data-server dbus_libs
                  vala libsecret libxml2 libsoup nspr nss intltool db ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--disable-fatal-warnings";

  NIX_CFLAGS_COMPILE = ["-I${nss.dev}/include/nss"
                        "-I${dbus-glib.dev}/include/dbus-1.0" "-I${dbus_libs.dev}/include/dbus-1.0"];

  enableParallelBuilding = true;

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Folks";

    homepage = https://wiki.gnome.org/Projects/Folks;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = gnome3.maintainers;
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
