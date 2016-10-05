{stdenv, fetchurl, which, openssl, ocaml, findlib}:

stdenv.mkDerivation rec {
  name = "ocaml-ssl-${version}";
  version = "0.5.2";

  src = fetchurl {
  url = "mirror://sourceforge/project/savonet/ocaml-ssl/0.5.2/ocaml-ssl-0.5.2.tar.gz";

    sha256 = "0341rm8aqrckmhag1lrqfnl17v6n4ci8ibda62ahkkn5cxd58cpp";
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
