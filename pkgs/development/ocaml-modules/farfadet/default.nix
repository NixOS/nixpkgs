{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg
, faraday
}:

if lib.versionOlder ocaml.version "4.3"
then throw "farfadet is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-farfadet";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/oklm-wsh/Farfadet/releases/download/v${version}/farfadet-${version}.tbz";
    sha256 = "0nlafnp0pwx0n4aszpsk6nvcvqi9im306p4jhx70si7k3xprlr2j";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  propagatedBuildInputs = [ faraday ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "A printf-like for Faraday library";
    homepage = "https://github.com/oklm-wsh/Farfadet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
