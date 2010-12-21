{stdenv, fetchurl, ocaml, pkgconfig, gtk, libgnomecanvas}:

stdenv.mkDerivation (rec {
  version = "2.14.2";
  name = "lablgtk-${version}";
  src = fetchurl {
    url = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/dist/${name}.tar.gz";
    sha256 = "1fnh0amm7lwgyjdhmlqgsp62gwlar1140425yc1j6inwmgnsp0a9";
  };

  buildInputs = [ocaml pkgconfig gtk libgnomecanvas];

  configureFlags = "--with-libdir=$(out)/lib/ocaml";
  buildFlags = "world";
  meta = {
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
})
