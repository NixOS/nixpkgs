{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, ctypes, result, SDL2, pkg-config, ocb-stubblr }:

if lib.versionOlder ocaml.version "4.03"
then throw "tsdl is not available for OCaml ${ocaml.version}"
else

let
  pname = "tsdl";
  version = "0.9.8";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256-zjXz2++42FHmbE0nIDeryNQeX+avGwh9rwAs8O0pZYU=";
  };

  nativeBuildInputs = [ pkg-config ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [ SDL2 ctypes ];

  preConfigure = ''
    # The following is done to avoid an additional dependency (ncurses)
    # due to linking in the custom bytecode runtime. Instead, just
    # compile directly into a native binary, even if it's just a
    # temporary build product.
    substituteInPlace myocamlbuild.ml \
      --replace ".byte" ".native"
  '';

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = webpage;
    description = "Thin bindings to the cross-platform SDL library";
    license = licenses.isc;
    inherit (ocaml.meta) platforms;
  };
}
