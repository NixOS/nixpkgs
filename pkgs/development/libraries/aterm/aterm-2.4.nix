{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.4";
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.4.tar.gz;
    md5 = "baf12d71372cfaa0d39145234e262fef";
  };
}
