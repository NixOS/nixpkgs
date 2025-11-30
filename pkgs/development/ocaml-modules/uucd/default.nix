{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  xmlm,
  topkg,
}:

let
  pname = "uucd";
  webpage = "https://erratique.ch/software/${pname}";
  version = "17.0.0";
in
stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-${pname}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    hash = "sha256-ifjEBUN+Lqw4W9FeoGX4XBjnxcJL15ukd+aSSDS8KC0=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  propagatedBuildInputs = [ xmlm ];

  meta = with lib; {
    description = "OCaml module to decode the data of the Unicode character database from its XML representation";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
