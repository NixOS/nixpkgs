{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, uunf, uucd }:

let
  pname = "uucp";
  version = "15.0.0";
  webpage = "https://erratique.ch/software/${pname}";
  minimumOCamlVersion = "4.03";
  doCheck = true;
in

if lib.versionOlder ocaml.version minimumOCamlVersion
then builtins.throw "${pname} needs at least OCaml ${minimumOCamlVersion}"
else

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256-rEeU9AWpCzuAtAOe7hJHBmJjP97BZsQsPFQQ8uZLUzA=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg uutf uunf uucd ];

  propagatedBuildInputs = [ uchar ];

  strictDeps = true;

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
    inherit (ocaml.meta) platforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
