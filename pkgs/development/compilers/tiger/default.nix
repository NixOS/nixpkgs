{stdenv, fetchurl, aterm, sdf, strategoxt}: derivation {
  name = "tiger-1.3-4631";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~mbravenb/dailydist/tiger/src/tiger-1.3-4631.tar.gz;
    md5 = "1ea6070d84134eb6cff7fb32a75ef90a";
  };
  stdenv = stdenv;
  aterm = aterm;
  sdf = sdf;
  strategoxt = strategoxt;
}
