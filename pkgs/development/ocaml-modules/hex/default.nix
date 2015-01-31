{ stdenv, fetchzip, ocaml, findlib }:

let version = "0.1.0"; in

stdenv.mkDerivation {
  name = "ocaml-hex-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-hex/archive/${version}.tar.gz";
    sha256 = "1nna0v5wi1g8l9ywl43xda2lqbz3sa3ncpyg84bl9baxyfmw4p9n";
  };

  buildInputs = [ ocaml findlib ];
  createFindlibDestdir = true;

  meta = {
    description = "Mininal OCaml library providing hexadecimal converters";
    homepage = https://github.com/mirage/ocaml-hex;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms;
  };
}
