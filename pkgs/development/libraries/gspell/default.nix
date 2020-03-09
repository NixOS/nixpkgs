{ stdenv, fetchurl, pkgconfig, libxml2, glib, gtk3, enchant2, isocodes, vala, gobject-introspection, gnome3 }:

let
  pname = "gspell";
  version = "1.8.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1s1dns070pz8dg04ppshdbx1r86n9406vkxcfs8hdghn0bfi9ras";
  };

  propagatedBuildInputs = [ enchant2 ]; # required for pkgconfig

  nativeBuildInputs = [ pkgconfig vala gobject-introspection libxml2 ];
  buildInputs = [ glib gtk3 isocodes ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A spell-checking library for GTK applications";
    homepage = https://wiki.gnome.org/Projects/gspell;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
