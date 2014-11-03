{stdenv, fetchurl, ocaml, findlib, mysql}:

# TODO: la versione stabile da' un errore di compilazione dovuto a
# qualche cambiamento negli header .h
# TODO: compilazione di moduli dipendenti da zip, ssl, tcl, gtk, gtk2

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "ocaml-mysql";
  version = "1.1.1";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/870/${pname}-${version}.tar.gz";
    sha256 = "f896fa101a05d81b85af8122fe1c2809008a5e5fdca00f9ceeb7eec356369e3a";
  };

  configureFlags = [ 
     "--prefix=$out" 
     "--libdir=$out/lib/ocaml/${ocaml_version}/site-lib/mysql"
  ];

  buildInputs = [ocaml findlib mysql];

  createFindlibDestdir = true;

  propagatedbuildInputs = [mysql];

  preConfigure = ''
    export LDFLAGS="-L${mysql}/lib/mysql"
  '';

  buildPhase = ''
    make
    make opt
  '';

  meta = {
    homepage = http://ocaml-mysql.forge.ocamlcore.org;
    description = "Bindings for interacting with MySQL databases from ocaml";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
