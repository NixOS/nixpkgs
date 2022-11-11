{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, cmdliner
, cmdlinerSupport ? lib.versionAtLeast cmdliner.version "1.1"
}:

let
  pname = "uunf";
  webpage = "https://erratique.ch/software/${pname}";
  version = "15.0.0";
in

if lib.versionOlder ocaml.version "4.03"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256-B/prPAwfqS8ZPS3fyDDIzXWRbKofwOCyCfwvh9veuug=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg uutf ]
  ++ lib.optional cmdlinerSupport cmdliner;

  propagatedBuildInputs = [ uchar ];

  strictDeps = true;

  prePatch = lib.optionalString stdenv.isAarch64 "ulimit -s 16384";

  buildPhase = ''
    runHook preBuild
    ${topkg.run} build \
      --with-uutf true \
      --with-cmdliner ${lib.boolToString cmdlinerSupport}
    runHook postBuild
  '';

  inherit (topkg) installPhase;

  meta = with lib; {
    description = "An OCaml module for normalizing Unicode text";
    homepage = webpage;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "unftrip";
    inherit (ocaml.meta) platforms;
  };
}
