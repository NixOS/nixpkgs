{ stdenv
, fetchurl
, ninja
, meson
, pkgconfig
, vala
, gobject-introspection
, glib
, libgudev
, libevdev
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "libmanette";
  version = "0.2.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1zxh7jn2zg7hivmal5zxam6fxvjsd1w6hlw0m2kysk76b8anbw60";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    libgudev
    libevdev
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A simple GObject game controller library";
    homepage = "https://gitlab.gnome.org/aplazas/libmanette";
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
