{
  lib,
  stdenv,
  fetchurl,
  buildDunePackage,
  ocaml,
  findlib,
  alcotest,
  astring,
  cmdliner,
  cppo,
  fmt,
  logs,
  ocaml-version,
  camlp-streams,
  lwt,
  re,
  result,
  csexp,
  gitUpdater,
}:

buildDunePackage (finalAttrs: {
  pname = "mdx";
  version = "2.5.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${finalAttrs.version}/mdx-${finalAttrs.version}.tbz";
    hash = "sha256-3YKYDdERpIBv+akdnS7Xwmrvsdp9zL0V5zw6j2boY/U=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [
    astring
    fmt
    logs
    csexp
    cmdliner
    ocaml-version
    camlp-streams
    re
    result
    findlib
  ];
  checkInputs = [
    alcotest
    lwt
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  outputs = [
    "bin"
    "lib"
    "out"
  ];

  installPhase = ''
    runHook preInstall
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib mdx
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Executable OCaml code blocks inside markdown files";
    homepage = "https://github.com/realworldocaml/mdx";
    changelog = "https://github.com/realworldocaml/mdx/raw/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "ocaml-mdx";
  };
})
