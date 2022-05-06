{ stdenv, lib, fetchurl
, ocaml, findlib
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-stdcompat";
  version = "18";

  src = fetchurl {
    url = "https://github.com/thierry-martinez/stdcompat/releases/download/v${version}/stdcompat-${version}.tar.gz";
    sha256 = "sha256:01y67rndjlzfp5zq0gbqpg9skqq2hfbvhbq9lfhhk5xidr98sfj8";
  };

  nativeBuildInputs = [ ocaml findlib ];

  strictDeps = true;

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
