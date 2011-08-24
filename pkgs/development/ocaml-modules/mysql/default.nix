{stdenv, fetchurl, ocaml, findlib, mysql}:

# TODO: la versione stabile da' un errore di compilazione dovuto a
# qualche cambiamento negli header .h
# TODO: compilazione di moduli dipendenti da zip, ssl, tcl, gtk, gtk2

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "ocaml-mysql";
  version = "1.0.4";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://raevnos.pennmush.org/code/${pname}/${pname}-${version}.tar.gz";
    sha256 = "17i5almar8qrhc9drq0cvlprxf9wi9szj5kh4gnz11l9al8i3lar";
  };

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
    homepage = http://raevnos.pennmush.org/code/ocaml-mysql/;
    description = "Bindings for interacting with MySQL databases from ocaml";
    license = "LGPLv2.1+";
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
