{stdenv, fetchurl, mk, ocaml, noweb, lua, groff }: 
stdenv.mkDerivation {
  name = "qcmm-2006-01-31";
  src = fetchurl {
    url = http://nixos.org/tarballs/qc--20060131.tar.gz;
    md5 = "9097830775bcf22c9bad54f389f5db23";
  };
  buildInputs = [ mk ocaml noweb groff ];
  patches = [ ./qcmm.patch ];
  builder = ./builder.sh;
  inherit lua;
}
