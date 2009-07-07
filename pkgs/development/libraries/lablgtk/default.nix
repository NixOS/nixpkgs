{stdenv, fetchurl, ocaml, pkgconfig, gtk, libgnomecanvas}:

stdenv.mkDerivation (rec {
  version = "2.12.0";
  name = "lablgtk-${version}";
  src = fetchurl {
    url = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/dist/${name}.tar.gz";
    sha256 = "1kflrg4rqqzrz0ffdzlhz510m82k21m5x78yr5nxd98avcd39qxk";
  };

  buildInputs = [ocaml pkgconfig gtk libgnomecanvas];

  configureFlags = "--with-libdir=$(out)/lib/ocaml";
  buildFlags = "world";
})
