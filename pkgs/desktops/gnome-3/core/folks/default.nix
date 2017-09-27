{ fetchurl, stdenv, pkgconfig, glib, gnome3, nspr, intltool
, vala_0_32, sqlite, libxml2, dbus_glib, libsoup, nss, dbus_libs
, telepathy_glib, evolution_data_server, libsecret, db }:

# TODO: enable more folks backends

let
  majorVersion = "0.11";
in
stdenv.mkDerivation rec {
  name = "folks-${majorVersion}.3";

  src = fetchurl {
    url = "mirror://gnome/sources/folks/${majorVersion}/${name}.tar.xz";
    sha256 = "2a2828a7c87fd39e5786f8f2cf0ebe47576a74974f1355c478a6dc747d7bcb64";
  };

  propagatedBuildInputs = [ glib gnome3.libgee sqlite ];
  # dbus_daemon needed for tests
  buildInputs = [ dbus_glib telepathy_glib evolution_data_server dbus_libs
                  vala_0_32 libsecret libxml2 libsoup nspr nss intltool db ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = "--disable-fatal-warnings";

  NIX_CFLAGS_COMPILE = ["-I${nss.dev}/include/nss"
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
