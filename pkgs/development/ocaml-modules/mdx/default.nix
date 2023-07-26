{ lib, fetchurl, buildDunePackage, ocaml, findlib
, alcotest
, astring, cppo, fmt, logs, ocaml-version, odoc-parser, lwt, re, csexp
, gitUpdater
}:

buildDunePackage rec {
  pname = "mdx";
  version = "2.3.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    hash = "sha256-MqCDmBAK/S0ueYi8O0XJtplxJx96twiFHe04Q8lHBmE=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ astring fmt logs csexp ocaml-version odoc-parser re findlib ];
  checkInputs = [ alcotest lwt ];

  doCheck = true;

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
