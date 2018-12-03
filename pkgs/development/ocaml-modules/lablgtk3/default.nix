{ stdenv, fetchurl, pkgconfig, ocaml, findlib, gtk3, gtkspell3, gtksourceview }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "lablgtk3 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "3.0.beta1";
  name = "ocaml${ocaml.version}-lablgtk3-${version}";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1769/lablgtk-3.0.beta1.tar.gz;
    sha256 = "08izn2kwxdz1i74m11lqkl9n50bs7sy6pl8mcq6br77znarvqb91";
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
