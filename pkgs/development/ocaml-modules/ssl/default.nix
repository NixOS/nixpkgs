{ stdenv, fetchzip, which, openssl, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ssl-${version}";
  version = "0.5.4";

  src = fetchzip {
    url = "https://github.com/savonet/ocaml-ssl/releases/download/${version}/ocaml-ssl-${version}.tar.gz";
    sha256 = "01sy3f94b463ff7dmkfsv67jh8g8h20wh7npjwqilniif7lgf4l3";
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
