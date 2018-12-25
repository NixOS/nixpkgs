{ stdenv, fetchurl, pkgconfig, ocaml, findlib, gtk3, gtkspell3, gtksourceview }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "lablgtk3 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "3.0.beta2";
  name = "ocaml${ocaml.version}-lablgtk3-${version}";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1774/lablgtk-3.0.beta2.tar.gz;
    sha256 = "1v4qj07l75hqis4j9bx8x1cfn7scqi6nmp4j5jx41x94ws7hp2ch";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib gtk3 gtkspell3 gtksourceview ];

  buildFlags = "world";

  meta = {
    description = "OCaml interface to gtk+-3";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
