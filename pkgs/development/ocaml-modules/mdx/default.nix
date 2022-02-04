{ lib, fetchurl, buildDunePackage, ocaml
, alcotest
, astring, cmdliner, cppo, fmt, logs, ocaml-version, odoc-parser, ocaml_lwt, re, result, csexp
, pandoc}:

buildDunePackage rec {
  pname = "mdx";
  version = "1.11.1";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    sha256 = "sha256:1q6169gmynnbrvlnzlmx7lpd6hwv6vwxg5j8ibc88wgs5s0r0fb0";
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
    homepage = "https://github.com/realworldocaml/mdx";
    description = "Executable OCaml code blocks inside markdown files";
    changelog = "https://github.com/realworldocaml/mdx/raw/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
