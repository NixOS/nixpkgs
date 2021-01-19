{ lib, fetchurl, buildDunePackage, opaline, ocaml
, alcotest
, astring, cmdliner, cppo, fmt, logs, ocaml-migrate-parsetree, ocaml-version, odoc, ocaml_lwt, pandoc, re }:

buildDunePackage rec {
  pname = "mdx";
  version = "1.8.0";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    sha256 = "1p2ip73da271as0x1gfbajik3mf1bkc8l54276vgacn1ja3saj52";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ astring fmt logs ocaml-migrate-parsetree ocaml-version odoc re ];
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
