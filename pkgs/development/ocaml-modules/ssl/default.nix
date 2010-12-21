{stdenv, fetchurl, which, openssl, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.4.4";
in

stdenv.mkDerivation {
  name = "ocaml-ssl-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/o/ocaml-ssl/ocaml-ssl_${version}.orig.tar.gz";
    sha256 = "1m45d0bd4ndxswaa1symp6c1npzjmm9pz0nf7w0q15gflqhba5ch";
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
