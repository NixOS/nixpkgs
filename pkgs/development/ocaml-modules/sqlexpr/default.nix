{ stdenv, fetchurl, buildDunePackage, ocaml_lwt
, lwt_ppx, ocaml-migrate-parsetree, ppx_tools_versioned, csv, ocaml_sqlite3
}:

buildDunePackage rec {
  pname = "sqlexpr";
  version = "0.9.0";

  src = fetchurl {
  url = "https://github.com/mfp/ocaml-sqlexpr/releases/download/${version}/ocaml-sqlexpr-${version}.tar.gz";
  sha256 = "0z0bkzi1mh0m39alzr2ds7hjpfxffx6azpfsj2wpaxrg64ks8ypd";
  };

  buildInputs = [ lwt_ppx ocaml-migrate-parsetree ppx_tools_versioned ];
  propagatedBuildInputs = [ ocaml_lwt csv ocaml_sqlite3 ];
  doCheck = true;

  preBuild = "rm META.sqlexpr";

  meta = {
    description = "Type-safe, convenient SQLite database access";
    homepage = "https://github.com/mfp/ocaml-sqlexpr";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
