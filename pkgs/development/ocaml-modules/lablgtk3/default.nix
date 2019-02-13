{ stdenv, fetchurl, pkgconfig, ocaml, findlib, gtk3, gtkspell3, gtksourceview }:

if !stdenv.lib.versionAtLeast ocaml.version "4.05"
then throw "lablgtk3 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "3.0.beta3";
  name = "ocaml${ocaml.version}-lablgtk3-${version}";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1775/lablgtk-3.0.beta3.tar.gz;
    sha256 = "174mwwdz1s91a6ycbas7nc0g87c2l6zqv68zi5ab33yb76l46a6w";
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
