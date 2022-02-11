{ stdenv, lib, fetchurl
, ocaml, findlib
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-stdcompat";
  version = "15";

  src = fetchurl {
    url = "https://github.com/thierry-martinez/stdcompat/releases/download/v${version}/stdcompat-${version}.tar.gz";
    sha256 = "1xcwb529m4lg9cbnxa9m3x2nnl9nxzz1x5lxpvdfflg4zxl6yx2y";
  };

  buildInputs = [ ocaml findlib ];
  # build fails otherwise
  enableParallelBuilding = false;

  configureFlags = "--libdir=$(OCAMLFIND_DESTDIR)";

  meta = {
    homepage = "https://github.com/thierry-martinez/stdcompat";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
