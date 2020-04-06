{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild
, cstruct, zarith, ounit, result, topkg, ptime
}:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then {
    version = "0.2.0";
    sha256 = "0yfq4hnyzx6hy05m60007cfpq88wxwa8wqzib19lnk2qrgy772mx";
    propagatedBuildInputs = [ ptime ];
  } else {
    version = "0.1.3";
    sha256 = "0hpn049i46sdnv2i6m7r6m6ch0jz8argybh71wykbvcqdby08zxj";
    propagatedBuildInputs = [ ];
  };
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-asn1-combinators-${version}";
  inherit (param) version;

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-asn1-combinators";
    rev    = "v${version}";
    inherit (param) sha256;
  };

  buildInputs = [ findlib ounit topkg ];
  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ result cstruct zarith ] ++ param.propagatedBuildInputs;

  buildPhase = "${topkg.run} build --tests true";

  inherit (topkg) installPhase;

  doCheck = true;
  checkPhase = "${topkg.run} test";

  meta = {
    homepage = https://github.com/mirleft/ocaml-asn1-combinators;
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
