{ stdenv, fetchurl, ocaml, findlib, uutf }:

let version = "0.9.1"; in

stdenv.mkDerivation {
  name = "ocaml-jsonm-${version}";

  src = fetchurl {
    url = "http://erratique.ch/software/jsonm/releases/jsonm-${version}.tbz";
    sha256 = "0wszqrmx8iqlwzvs76fjf4sqh15mv20yjrbyhkd348yq8nhdrm1z";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ uutf ];

  unpackCmd = "tar xjf $src";

  configurePhase = "ocaml setup.ml -configure --prefix $prefix";
  buildPhase = "ocaml setup.ml -build";
  createFindlibDestdir = true;
  installPhase = "ocaml setup.ml -install";

  meta = {
    description = "An OCaml non-blocking streaming codec to decode and encode the JSON data format";
    homepage = http://erratique.ch/software/jsonm;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
