{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uucp, uutf, cmdliner
, version ? if lib.versionAtLeast ocaml.version "4.14" then "16.0.0" else "15.0.0"
, cmdlinerSupport ? lib.versionAtLeast cmdliner.version "1.1"
}:

let
  pname = "uuseg";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation rec {

  name = "ocaml${ocaml.version}-${pname}-${version}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    hash = {
      "16.0.0" = "sha256-WAP9uyofhtw6ag6/U4GQAanIFoKWvyA4NgeVweTs/iQ=";
      "15.0.0" = "sha256-q8x3bia1QaKpzrWFxUmLWIraKqby7TuPNGvbSjkY4eM=";
    }."${version}";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [  topkg uutf ]
  ++ lib.optional cmdlinerSupport cmdliner;
  propagatedBuildInputs = [ uucp ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild
    ${topkg.run} build \
      --with-uutf true \
      --with-cmdliner ${lib.boolToString cmdlinerSupport}
    runHook postBuild
  '';

  inherit (topkg) installPhase;

  meta = with lib; {
    description = "OCaml library for segmenting Unicode text";
    homepage = webpage;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "usegtrip";
    inherit (ocaml.meta) platforms;
  };
}
