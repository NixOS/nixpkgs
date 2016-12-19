{ stdenv, buildOcaml, fetchurl, ocaml_batteries, csv, ocaml_lwt, ocaml_sqlite3, estring }:

buildOcaml rec {
  name = "sqlexpr";
  version = "0.5.5";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1203/ocaml-sqlexpr-${version}.tar.gz";
    sha256 = "02pi0xxr3xzalwpvcaq96k57wz2vxj20l2mga1a4d2ddvhran8kr";
  };

  propagatedBuildInputs = [ ocaml_batteries csv ocaml_lwt ocaml_sqlite3 estring ];

  meta = with stdenv.lib; {
    homepage = "http://github.com/mfp/ocaml-sqlexpr";
    description = "Type-safe, convenient SQLite database access";
    license = licenses.lgpl21;
  };
}
