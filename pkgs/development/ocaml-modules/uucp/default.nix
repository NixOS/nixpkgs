{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, uunf, uucd }:

let
  pname = "uucp";
  version = "13.0.0";
  webpage = "https://erratique.ch/software/${pname}";
  minimumOCamlVersion = "4.03";
  doCheck = true;
in

if !(lib.versionAtLeast ocaml.version minimumOCamlVersion)
then builtins.throw "${pname} needs at least OCaml ${minimumOCamlVersion}"
else

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256-OPpHbCOC/vMFdyHwyhCSisUv2PyO8xbeY2oq1a9HbqY=";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg uutf uunf ];

  propagatedBuildInputs = [ uchar ];

  buildPhase = ''
    runHook preBuild
    ${topkg.buildPhase} --with-cmdliner false --tests ${lib.boolToString doCheck}
    runHook postBuild
  '';

  inherit (topkg) installPhase;

  inherit doCheck;
  checkPhase = ''
    runHook preCheck
    ${topkg.run} test
    runHook postCheck
  '';
  checkInputs = [ uucd ];

  meta = with lib; {
    description = "An OCaml library providing efficient access to a selection of character properties of the Unicode character database";
    homepage = webpage;
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
