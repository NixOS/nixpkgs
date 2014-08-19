{stdenv, fetchurl, ocaml, findlib, pkgconfig, gtk, libgnomecanvas, libglade, gtksourceview}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "lablgtk";
  version = "2.16.0";
in

stdenv.mkDerivation (rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/979/${name}.tar.gz";
    sha256 = "a0ea9752eb257dadcfc2914408fff339d4c34357802f02c63329dd41b777de2f";
  };

  buildInputs = [ocaml findlib pkgconfig gtk libgnomecanvas libglade gtksourceview];

  configureFlags = "--with-libdir=$(out)/lib/ocaml/${ocaml_version}/site-lib";
  buildFlags = "world";

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml_version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml_version}/site-lib/:$OCAMLPATH
  '';

  meta = {
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
      stdenv.lib.maintainers.roconnor
    ];
    homepage = http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgtk.html;
    description = "LablGTK is is an Objective Caml interface to gtk+";
    license = stdenv.lib.licenses.lgpl21Plus;
  };
})
