{stdenv, fetchurl, ocaml, findlib, pkgconfig, gtk, libgnomecanvas, libglade, gtksourceview}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "lablgtk";
  version = "2.14.2";
in

stdenv.mkDerivation (rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/dist/${name}.tar.gz";
    sha256 = "1fnh0amm7lwgyjdhmlqgsp62gwlar1140425yc1j6inwmgnsp0a9";
  };

  buildInputs = [ocaml findlib pkgconfig gtk libgnomecanvas libglade gtksourceview];

  patches = [ ./META.patch ];

  configureFlags = "--with-libdir=$(out)/lib/ocaml/${ocaml_version}/site-lib";
  buildFlags = "world";

  postInstall = ''
    ocamlfind install lablgtk2 META
  '';

  meta = {
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
      stdenv.lib.maintainers.roconnor
    ];
    homepage = http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgtk.html;
    description = "LablGTK is is an Objective Caml interface to gtk+";
    license = "LGPLv2.1+";
  };
})
