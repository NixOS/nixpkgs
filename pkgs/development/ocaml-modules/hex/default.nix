{ stdenv, fetchurl, ocaml, findlib, dune, cstruct }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "hex is not available for OCaml ${ocaml.version}"
else

let version = "1.2.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-hex-${version}";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-hex/releases/download/v1.2.0/hex-1.2.0.tbz";
    sha256 = "17hqf7z5afp2z2c55fk5myxkm7cm74259rqm94hcxkqlpdaqhm8h";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml findlib dune ];
  propagatedBuildInputs = [ cstruct ];

  buildPhase = "dune build -p hex";
  doCheck = true;
  checkPhase = "jbuilder runtest";
  inherit (dune) installPhase;

  meta = {
    description = "Mininal OCaml library providing hexadecimal converters";
    homepage = https://github.com/mirage/ocaml-hex;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
