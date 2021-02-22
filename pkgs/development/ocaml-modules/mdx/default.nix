{ lib, fetchurl, buildDunePackage, opaline, ocaml
, alcotest
, astring, cmdliner, cppo, fmt, logs, ocaml-version, odoc, ocaml_lwt, re, result, csexp
, pandoc}:

buildDunePackage rec {
  pname = "mdx";
  version = "1.8.1";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    sha256 = "1szik1lyg2vs8jrisnvjdc29n0ifls8mghimff4jcz6f48haa3cv";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ astring fmt logs result csexp ocaml-version odoc re ];
  checkInputs = [ alcotest ocaml_lwt pandoc ];

  doCheck = true;

  outputs = [ "bin" "lib" "out" ];

  installPhase = ''
    ${opaline}/bin/opaline -prefix $bin -libdir $lib/lib/ocaml/${ocaml.version}/site-lib
  '';

  meta = {
    homepage = "https://github.com/realworldocaml/mdx";
    description = "Executable OCaml code blocks inside markdown files";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
