{stdenv, fetchurl, aterm, sdf}: derivation {
  name = "strategoxt-0.9.4-4626";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://losser.labs.cs.uu.nl/~mbravenb/dailydist/strategoxt/src/strategoxt-0.9.4-4626.tar.gz;
    md5 = "f33ae9fdb9d8628ae01fa0f26bfa0429"
  };
  stdenv = stdenv;
  aterm = aterm;
  sdf = sdf;
  tarfile = "true";
  dir = "strategoxt";
}
