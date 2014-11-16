{ stdenv, fetchurl, ocaml, findlib, which }:

let inherit (stdenv.lib) getVersion versionAtLeast; in

assert versionAtLeast (getVersion ocaml) "4.00.0";
assert versionAtLeast (getVersion findlib) "1.3.3";

stdenv.mkDerivation rec {

  name = "bolt-1.4";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1043/${name}.tar.gz";
    sha256 = "1c807wrpxra9sbb34lajhimwra28ldxv04m570567lh2b04n38zy";
  };

  buildInputs = [ ocaml findlib which ];

  # The custom `configure` script does not expect the --prefix
  # option. Installation is handled by ocamlfind.
  dontAddPrefix = true;

  createFindlibDestdir = true;

  buildFlags = "all";

  doCheck = true;
  checkTarget = "tests";

  meta = with stdenv.lib; {
    homepage = "http://bolt.x9c.fr";
    description = "A logging tool for the OCaml language";
    longDescription = ''
      Bolt is a logging tool for the OCaml language. It is inspired by and
      modeled after the famous log4j logging framework for Java.
    '';
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
