{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, js_of_ocaml
, jsooSupport ? true
}:

with lib;

let param =
  if versionAtLeast ocaml.version "4.03"
  then {
    version = "1.1.0";
    sha256 = "1qb4ljwirrc3g8brh97s76rjky2cpmy7zm87y7iqd6pxix52ydk3";
  } else {
    version = "0.8.4";
    sha256 = "1adm8sc3lkjly99hyi5gqnxas748k7h62ljgn8x423nkn8gyp8dh";
  };
in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-mtime-${param.version}";

  src = fetchurl {
    url = "http://erratique.ch/software/mtime/releases/mtime-${param.version}.tbz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ]
  ++ stdenv.lib.optional jsooSupport js_of_ocaml;

  buildPhase = "${topkg.buildPhase} --with-js_of_ocaml ${boolToString jsooSupport}";

  inherit (topkg) installPhase;

  meta = {
    description = "Monotonic wall-clock time for OCaml";
    homepage = https://erratique.ch/software/mtime;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
