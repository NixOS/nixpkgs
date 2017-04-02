{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_tools, ppx_driver
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_pipebang-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_pipebang-113.33.00+4.03.tar.gz;
    sha256 = "1rjrpbncy8vzwnmc5n0qs4dd40dmg4h75dvd7h7lm8cpxalifivc";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ ppx_driver ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
