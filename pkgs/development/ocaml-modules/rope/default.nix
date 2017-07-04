{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, camlp4, benchmark }:

let version = "0.5"; in

stdenv.mkDerivation {
  name = "rope-${version}";

  src = fetchzip {
    url = "https://forge.ocamlcore.org/frs/download.php/1156/rope-${version}.tar.gz";
    sha256 = "1i8kzg19jrapl30mq8m91vy09z0r0dl4bnpw24ga96w8pxqf9qhd";
  };

  buildInputs = [ ocaml findlib ocamlbuild camlp4 benchmark ];

  createFindlibDestdir = true;

  meta = {
    homepage = http://rope.forge.ocamlcore.org/;
    platforms = ocaml.meta.platforms or [];
    description = ''Ropes ("heavyweight strings") in OCaml'';
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ volth ];
  };
}
