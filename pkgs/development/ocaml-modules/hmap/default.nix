{ stdenv
, lib
, fetchurl
, findlib
, ocaml
, ocamlbuild
, topkg
}:

let
  minimumSupportedOcamlVersion = "4.02.0";
in
assert lib.versionOlder minimumSupportedOcamlVersion ocaml.version;

stdenv.mkDerivation rec {
  pname = "hmap";
  version = "0.8.1";
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "http://erratique.ch/software/hmap/releases/${pname}-${version}.tbz";
    sha256 = "10xyjy4ab87z7jnghy0wnla9wrmazgyhdwhr4hdmxxdn28dxn03a";
  };

  nativeBuildInputs = [ ocaml ocamlbuild findlib topkg ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) installPhase;

  buildPhase = "${topkg.run} build --tests true";

  doCheck = true;

  checkPhase = "${topkg.run} test";

  meta = {
    description = "Heterogeneous value maps for OCaml";
    homepage = "https://erratique.ch/software/hmap";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.pmahoney ];
  };
}
