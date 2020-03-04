{ lib, fetchurl, buildDunePackage, opaline, ocaml
, astring, cmdliner, cppo, fmt, logs, ocaml-migrate-parsetree, ocaml-version, ocaml_lwt, pandoc, re }:

buildDunePackage rec {
  pname = "mdx";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/1.5.0/mdx-1.5.0.tbz";
    sha256 = "0g45plf4z7d178gp0bx7842fwbd3m19679yfph3s95da6mrfm3xn";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ astring fmt logs ocaml-migrate-parsetree ocaml-version re ];
  checkInputs = lib.optionals doCheck [ ocaml_lwt pandoc ];

  doCheck = true;

  dontStrip = lib.versions.majorMinor ocaml.version == "4.04";

  outputs = [ "bin" "lib" "out" ];

  installPhase = ''
    ${opaline}/bin/opaline -prefix $bin -libdir $lib/lib/ocaml/${ocaml.version}/site-lib
  '';

  meta = {
    homepage = https://github.com/realworldocaml/mdx;
    description = "Executable OCaml code blocks inside markdown files";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
