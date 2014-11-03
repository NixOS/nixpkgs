{stdenv, fetchurl, which, openssl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.4.7";
in

stdenv.mkDerivation {
  name = "ocaml-ssl-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/o/ocaml-ssl/ocaml-ssl_${version}.orig.tar.gz";
    sha256 = "0i0j89b10n3xmmawcq4qfwa42133pddw4x5nysmsnpd15srv5gp9";
  };

  buildInputs = [which openssl ocaml findlib];

  dontAddPrefix = true;

  configureFlags = "--disable-ldconf";

  createFindlibDestdir = true;

  meta = {
    homepage = http://savonet.rastageeks.org/;
    description = "OCaml bindings for libssl ";
    license = "LGPL+link exception";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
