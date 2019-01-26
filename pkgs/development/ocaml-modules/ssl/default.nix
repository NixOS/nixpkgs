{ stdenv, fetchzip, which, openssl, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ssl-${version}";
  version = "0.5.5";

  src = fetchzip {
    url = "https://github.com/savonet/ocaml-ssl/releases/download/${version}/ocaml-ssl-${version}.tar.gz";
    sha256 = "0j5zvsx51dg5r7sli7bakv7gfd29z890h0xzi876pg9vywwz9w7l";
  };

  buildInputs = [which ocaml findlib];

  propagatedBuildInputs = [openssl];

  dontAddPrefix = true;

  createFindlibDestdir = true;

  meta = {
    homepage = http://savonet.rastageeks.org/;
    description = "OCaml bindings for libssl ";
    license = "LGPL+link exception";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
