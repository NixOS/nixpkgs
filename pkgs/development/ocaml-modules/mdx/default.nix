{ lib, fetchFromGitHub, buildDunePackage, ocaml
, alcotest
, astring, cmdliner, cppo, fmt, logs, ocaml-version, odoc-parser, ocaml_lwt, re, result, csexp
, pandoc
, gitUpdater
}:

buildDunePackage rec {
  pname = "mdx";
  version = "2.1.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "realworldocaml";
    repo = pname;
    rev = version;
    hash = "sha256-p7jmksltgfLFTSkPxMuJWJexLq2VvPWT/DJtDveOL/A=";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ astring fmt logs result csexp ocaml-version odoc-parser re ];
  checkInputs = [ alcotest ocaml_lwt pandoc ];

  # Check fails with cmdliner ≥ 1.1
  doCheck = false;

  outputs = [ "bin" "lib" "out" ];

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
