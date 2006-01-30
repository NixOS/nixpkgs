{stdenv, fetchurl, pcre, libpng}:

stdenv.mkDerivation {
  name = "slang-2.0.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/slang-2.0.5.tar.bz2;
    md5 = "8b6afa085f76b1be29825f0c470b6cad";
  };
  buildInputs = [pcre libpng];
}
