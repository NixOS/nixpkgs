{ lib, fetchurl, buildDunePackage, ocaml
, alcotest
, astring, cmdliner, cppo, fmt, logs, ocaml-version, odoc-parser, ocaml_lwt, re, result, csexp
, pandoc}:

buildDunePackage rec {
  pname = "mdx";
  version = "2.1.0";
  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    sha256 = "sha256-ol1zy8LODDYdcnv/jByE0pnqJ5ujQuMALq3v9y7td/o=";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ astring fmt logs result csexp ocaml-version odoc-parser re ];
  checkInputs = [ alcotest ocaml_lwt pandoc ];

  doCheck = true;

  outputs = [ "bin" "lib" "out" ];

  installPhase = ''
    runHook preInstall
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib ${pname}
    runHook postInstall
  '';

  meta = {
    description = "Executable OCaml code blocks inside markdown files";
    homepage = "https://github.com/realworldocaml/mdx";
    changelog = "https://github.com/realworldocaml/mdx/raw/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
    mainProgram = "ocaml-mdx";
  };
}
