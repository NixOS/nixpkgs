{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, opam, cmdliner }:

stdenv.mkDerivation rec {
  version = "0.9.6";
  name = "uuidm-${version}"; 
  src = fetchurl {
    url = "http://erratique.ch/software/uuidm/releases/uuidm-${version}.tbz";
    sha256 = "0hz4fdx0x16k0pw9995vkz5d1hmzz6b16wck9li399rcbfnv5jlc";
  };

  unpackCmd = "tar -xf $curSrc";

  buildInputs = [ ocaml findlib ocamlbuild topkg opam cmdliner ];

  inherit (topkg) buildPhase installPhase;

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An OCaml module implementing 128 bits universally unique identifiers version 3, 5 (name based with MD5, SHA-1 hashing) and 4 (random based) according to RFC 4122";
    homepage = http://erratique.ch/software/uuidm;
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.maurer ];
  };
}
