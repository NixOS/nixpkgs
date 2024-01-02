{ stdenv, lib, fetchurl, fetchpatch, ocaml, findlib, libmysqlclient }:

# TODO: la versione stabile da' un errore di compilazione dovuto a
# qualche cambiamento negli header .h
# TODO: compilazione di moduli dipendenti da zip, ssl, tcl, gtk, gtk2

let
  pname = "ocaml-mysql";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "http://ygrek.org.ua/p/release/ocaml-mysql/${name}.tar.gz";
    sha256 = "06mb2bq7v37wn0lza61917zqgb4bsg1xxb73myjyn88p6khl6yl2";
  };

  configureFlags = [
     "--prefix=$out"
     "--libdir=$out/lib/ocaml/${ocaml.version}/site-lib/mysql"
  ];

  nativeBuildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  propagatedBuildInputs = [ libmysqlclient ];

  strictDeps = true;

  patches = [
    (fetchpatch {
      url = "https://github.com/ygrek/ocaml-mysql/compare/v1.2.1...d6d1b3b262ae2cf493ef56f1dd7afcf663a70a26.patch";
      sha256 = "0018s2wcrvbsw9yaqmwq500qmikwffrgdp5xg9b8v7ixhd4gi6hn";
    })
  ];

  meta = {
    homepage = "http://ocaml-mysql.forge.ocamlcore.org";
    description = "Bindings for interacting with MySQL databases from ocaml";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.roconnor ];
  };
}
