{stdenv, fetchurl, ocaml, perl}: stdenv.mkDerivation {
  name = "cil-1.3.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/cil-1.3.2.tar.gz;
    md5 = "aba80dd700fcb1411598670cc36a9573";
  };
  buildInputs = [ocaml perl];
}
