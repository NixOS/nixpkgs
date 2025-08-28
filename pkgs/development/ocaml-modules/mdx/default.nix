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

buildDunePackage rec {
  pname = "mdx";
  version = "2.5.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    hash = "sha256-wtpY19UYLxXARvsyC7AsFmAtLufLmfNJ4/SEHCY2UCk=";
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
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib ${pname}
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Executable OCaml code blocks inside markdown files";
    homepage = "https://github.com/realworldocaml/mdx";
    changelog = "https://github.com/realworldocaml/mdx/raw/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "ocaml-mdx";
  };
}
