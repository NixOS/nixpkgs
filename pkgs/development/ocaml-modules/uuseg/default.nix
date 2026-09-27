{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  uucp,
  uutf,
  cmdliner,
  version ? if lib.versionAtLeast ocaml.version "4.14" then "18.0.0" else "15.0.0",
  cmdlinerSupport ? lib.versionAtLeast cmdliner.version "1.1",
}:

stdenv.mkDerivation (finalAttrs: {
  name = "ocaml${ocaml.version}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "uuseg";
  inherit version;

  src = fetchurl {
    url = "https://erratique.ch/software/uuseg/releases/uuseg-${finalAttrs.version}.tbz";
    hash =
      {
        "18.0.0" = "sha256-bXzGAF6U+HH6B0TEzvPuB25fC+TlMcSu7wy4budLvRA=";
        "15.0.0" = "sha256-q8x3bia1QaKpzrWFxUmLWIraKqby7TuPNGvbSjkY4eM=";
      }
      ."${finalAttrs.version}";
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
  ]
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

  meta = {
    description = "OCaml library for segmenting Unicode text";
    homepage = "https://erratique.ch/software/uuseg";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "usegtrip";
    inherit (ocaml.meta) platforms;
  };
})
