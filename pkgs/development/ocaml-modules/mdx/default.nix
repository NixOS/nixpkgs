{ lib, fetchurl, buildDunePackage, ocaml, findlib
, alcotest
, astring, cppo, fmt, logs, ocaml-version, camlp-streams, lwt, re, csexp
, gitUpdater
}:

buildDunePackage rec {
  pname = "mdx";
  version = "2.3.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    hash = "sha256-mkCkX6p41H4pOSvU/sJg0UAWysGweOSrAW6jrcCXQ/M=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ astring fmt logs csexp ocaml-version camlp-streams re findlib ];
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
