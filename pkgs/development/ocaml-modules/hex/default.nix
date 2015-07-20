{ stdenv, fetchzip, ocaml, findlib, cstruct }:

let version = "0.2.0"; in

stdenv.mkDerivation {
  name = "ocaml-hex-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-hex/archive/${version}.tar.gz";
    sha256 = "13vmpxwg5vb2qvkdqz37rx1ya19r9cp4dwylx8jj15mn77hpy7xg";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ cstruct ];
  createFindlibDestdir = true;

  meta = {
    description = "Mininal OCaml library providing hexadecimal converters";
    homepage = https://github.com/mirage/ocaml-hex;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms;
  };
}
