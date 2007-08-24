{stdenv, fetchurl, pcre, libpng}:

stdenv.mkDerivation {
  name = "slang-2.0.5";
  src = fetchurl {
    url = ftp://space.mit.edu/pub/davis/slang/v2.0/slang-2.0.5.tar.bz2;
    md5 = "8b6afa085f76b1be29825f0c470b6cad";
  };
  buildInputs = [pcre libpng];
}
