{ stdenv, fetchzip, which, openssl, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ssl-${version}";
  version = "0.5.3";

  src = fetchzip {
    url = "https://github.com/savonet/ocaml-ssl/releases/download/0.5.3/ocaml-ssl-${version}.tar.gz";
    sha256 = "0h2k19zpdvq1gqwrmmgkibw4j48l71vv6ajzxs0wi71y80c1vhwm";
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
