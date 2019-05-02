{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, topkg, astring }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ocb-stubblr-0.1.0";
  src = fetchzip {
    url = https://github.com/pqwy/ocb-stubblr/releases/download/v0.1.0/ocb-stubblr-0.1.0.tbz;
    name = "src.tar.bz";
    sha256 = "0hpds1lkq4j8wgslv7hnirgfrjmqi36h5rarpw9mwf24gfp5ays2";
  };

  patches = [ ./pkg-config.patch ];

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  propagatedBuildInputs = [ astring ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "OCamlbuild plugin for C stubs";
    homepage = https://github.com/pqwy/ocb-stubblr;
    license = stdenv.lib.licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
