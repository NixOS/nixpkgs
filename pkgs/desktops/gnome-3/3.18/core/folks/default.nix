{ fetchurl, stdenv, pkgconfig, glib, gnome3, nspr, intltool
, vala, sqlite, libxml2, dbus_glib, libsoup, nss, dbus_libs
, telepathy_glib, evolution_data_server, libsecret, db }:

# TODO: enable more folks backends

let
  majorVersion = "0.11";
in
stdenv.mkDerivation rec {
  name = "folks-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/folks/${majorVersion}/${name}.tar.xz";
    sha256 = "0q9hny6a38zn0gamv0ji0pn3jw6bpn2i0fr6vbzkhm9h9ws0cqvz";
  };

  propagatedBuildInputs = [ glib gnome3.libgee sqlite ];
  # dbus_daemon needed for tests
  buildInputs = [ dbus_glib telepathy_glib evolution_data_server dbus_libs
                  vala libsecret libxml2 libsoup nspr nss intltool db ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--disable-fatal-warnings";

  NIX_CFLAGS_COMPILE = ["-I${nspr.dev}/include/nspr" "-I${nss.dev}/include/nss"
                        "-I${dbus_glib.dev}/include/dbus-1.0" "-I${dbus_libs.dev}/include/dbus-1.0"];

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
