{ stdenv, fetchurl, ocaml, findlib, mysql }:

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

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  propagatedBuildInputs = [ mysql.client ];

  meta = {
    homepage = http://ocaml-mysql.forge.ocamlcore.org;
    description = "Bindings for interacting with MySQL databases from ocaml";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
