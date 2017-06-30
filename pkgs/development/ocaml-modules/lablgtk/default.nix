{stdenv, fetchurl, ocaml, findlib, pkgconfig, gtk2, libgnomecanvas, libglade, gtksourceview, camlp4}:

let
  pname = "lablgtk";
in

assert stdenv.lib.versionAtLeast ocaml.version "3.12";

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "2.18.5";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1627/lablgtk-2.18.5.tar.gz;
    sha256 = "0cyj6sfdvzx8hw7553lhgwc0krlgvlza0ph3dk9gsxy047dm3wib";
  };

  buildInputs = [ocaml findlib pkgconfig gtk2 libgnomecanvas libglade gtksourceview camlp4];

  configureFlags = "--with-libdir=$(out)/lib/ocaml/${ocaml.version}/site-lib";
  buildFlags = "world";

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      z77z roconnor vbgl
    ];
    homepage = http://lablgtk.forge.ocamlcore.org/;
    description = "An OCaml interface to gtk+";
    license = licenses.lgpl21Plus;
  };
}
