{ stdenv, fetchurl, ocaml, findlib, dune, ocaml_lwt
, lwt_ppx, ocaml-migrate-parsetree, ppx_tools_versioned, csv, ocaml_sqlite3
}:

stdenv.mkDerivation rec {
  version = "0.9.0";
  name = "ocaml${ocaml.version}-sqlexpr-${version}";

  src = fetchurl {
  url = "https://github.com/mfp/ocaml-sqlexpr/releases/download/${version}/ocaml-sqlexpr-${version}.tar.gz";
  sha256 = "0z0bkzi1mh0m39alzr2ds7hjpfxffx6azpfsj2wpaxrg64ks8ypd";
  };

  buildInputs = [ ocaml findlib dune lwt_ppx ocaml-migrate-parsetree ppx_tools_versioned ];

  propagatedBuildInputs = [ ocaml_lwt csv ocaml_sqlite3 ];

  buildPhase = "dune build -p sqlexpr";

  doCheck = true;
  checkPhase = "dune runtest -p sqlexpr";

  inherit (dune) installPhase;

  meta = {
    description = "Type-safe, convenient SQLite database access";
    homepage = "https://github.com/mfp/ocaml-sqlexpr";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
