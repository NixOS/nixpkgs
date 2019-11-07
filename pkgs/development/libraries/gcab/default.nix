{ stdenv
, fetchurl
, gettext
, gobject-introspection
, pkgconfig
, meson
, ninja
, git
, vala
, glib
, zlib
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gcab";
  version = "1.2";

  outputs = [ "bin" "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "038h5kk41si2hc9d9169rrlvp8xgsxq27kri7hv2vr39gvz9cbas";
  };

  nativeBuildInputs = [
    meson
    ninja
    git
    pkgconfig
    vala
    gettext
    gobject-introspection
  ];

  buildInputs = [
    glib
    zlib
  ];

  mesonFlags = [
    "-Ddocs=false"
    "-Dtests=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "GObject library to create cabinet files";
    homepage = "https://gitlab.gnome.org/GNOME/gcab";
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
