{stdenv, fetchurl, aterm, sdf}: derivation {
  name = "strategoxt-0.9.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/~eelco/stratego/strategoxt-0.9.4/strategoxt-0.9.4.tar.gz;
    md5 = "4a689e753969ce653b6ea83853890529";
  };
  stdenv = stdenv;
  aterm = aterm;
  sdf = sdf;
  tarfile = "true";
  dir = "strategoxt";
}
