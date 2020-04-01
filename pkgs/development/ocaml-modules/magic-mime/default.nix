{ stdenv, fetchzip, ocaml, findlib, ocamlbuild }:

let version = "1.0.0"; in

stdenv.mkDerivation {
  pname = "ocaml-magic-mime";
  inherit version;

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-magic-mime/archive/v${version}.tar.gz";
    sha256 = "058d83hmxd5mjccxdm3ydchmhk2lca5jdg82jg0klsigmf4ida6v";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ findlib ];
  configurePlatforms = [];

  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/mirage/ocaml-magic-mime";
    description = "Convert file extensions to MIME types";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
