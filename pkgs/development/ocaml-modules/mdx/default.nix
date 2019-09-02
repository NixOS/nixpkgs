{ stdenv, fetchFromGitHub, buildDunePackage, astring, cmdliner, cppo, fmt, logs, ocaml-migrate-parsetree, ocaml_lwt, pandoc, re }:

buildDunePackage rec {
  pname = "mdx";
  version = "1.4.0";

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "realworldocaml";
    repo = pname;
    rev = version;
    sha256 = "0ljd00d261s2wf7cab086asqi39icf9zs4nylni6dldaqb027d4w";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ astring cmdliner fmt logs ocaml-migrate-parsetree re ];
  checkInputs = [ ocaml_lwt pandoc ];

  doCheck = true;

  meta = {
    homepage = https://github.com/realworldocaml/mdx;
    description = "Executable OCaml code blocks inside markdown files";
    license = stdenv.lib.licenses.isc;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
