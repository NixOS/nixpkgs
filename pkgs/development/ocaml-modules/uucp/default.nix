{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  uchar,
  uutf,
  uunf,
  uucd,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "ocaml${ocaml.version}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "uucp";
  version = "17.0.0";

  src = fetchurl {
    url = "https://erratique.ch/software/uucp/releases/uucp-${finalAttrs.version}.tbz";
    hash = "sha256-mSQtTn4DYa15pYWFt0J+/BEpJRaa+6uIKnifMV4Euhs=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [
    topkg
    uutf
    uunf
    uucd
  ];

  propagatedBuildInputs = [ uchar ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild
    ${topkg.buildPhase} --with-cmdliner false --tests ${lib.boolToString finalAttrs.doCheck}
    runHook postBuild
  '';

  inherit (topkg) installPhase;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ${topkg.run} test
    runHook postCheck
  '';
  checkInputs = [ uucd ];

  meta = {
    description = "OCaml library providing efficient access to a selection of character properties of the Unicode character database";
    homepage = "https://erratique.ch/software/uucp";
    inherit (ocaml.meta) platforms;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
