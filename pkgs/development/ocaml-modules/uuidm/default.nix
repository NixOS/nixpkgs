{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation rec {
  version = "0.9.5";
  name = "uuidm-${version}"; 
  src = fetchurl {
    url = "http://erratique.ch/software/uuidm/releases/uuidm-${version}.tbz";
    sha256 = "03bgxs119bphv9ggg97nsl5m61s43ixgby05hhggv16iadx9zndm";
  };

  unpackCmd = "tar -xf $curSrc";

  buildInputs = [ocaml findlib];

  configurePhase = "ocaml setup.ml -configure --prefix $prefix";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An OCaml module implementing 128 bits universally unique identifiers version 3, 5 (name based with MD5, SHA-1 hashing) and 4 (random based) according to RFC 4122";
    homepage = http://erratique.ch/software/uuidm;
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.maurer ];
  };
}
