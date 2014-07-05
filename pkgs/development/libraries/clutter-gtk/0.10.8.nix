{ fetchurl, stdenv, pkgconfig, clutter, gtk }:

stdenv.mkDerivation rec {
  name = "clutter-gtk-0.10.8";

  src = fetchurl {
    src = "mirror://gnome/sources/clutter-gtk/0.10/${name}.tar.bz2";
    sha256 = "7867f951568871d9f68cbe8a3644fd53d2138f725b7ba61ffc0053eb64e80814";
  };

  propagatedBuildInputs = [ clutter gtk ];
  nativeBuildInputs = [ pkgconfig ];

  configureFlags = [ "--disable-introspection" ]; # not needed anywhere AFAIK

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "Clutter-GTK";

    homepage = http://www.clutter-project.org/;

    license = "LGPLv2+";

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
