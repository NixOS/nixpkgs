{ fetchurl, stdenv, glib, pkgconfig, gettext }:


stdenv.mkDerivation rec {
  name = "gts-${version}";
  version = "0.7.6";

  src = fetchurl {
    url = "mirror://sourceforge/gts/${name}.tar.gz";
    sha256 = "07mqx09jxh8cv9753y2d2jsv7wp8vjmrd7zcfpbrddz3wc9kx705";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gettext ];

  meta = {
    homepage = http://gts.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl2Plus;
    description = "GNU Triangulated Surface Library";

    longDescription = ''
      Library intended to provide a set of useful functions to deal with
      3D surfaces meshed with interconnected triangles.
    '';

    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
