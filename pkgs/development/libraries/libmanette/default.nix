{ stdenv, fetchurl, ninja, meson, pkgconfig, vala, gobject-introspection
, glib, libgudev, libevdev, gnome3 }:

let
  version = "0.2.3";
  pname = "libmanette";
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1zxh7jn2zg7hivmal5zxam6fxvjsd1w6hlw0m2kysk76b8anbw60";
  };

  nativeBuildInputs = [ meson ninja pkgconfig vala gobject-introspection ];
  buildInputs = [ glib libgudev libevdev ];

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A simple GObject game controller library";
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
