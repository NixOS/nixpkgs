{stdenv, fetchurl}: derivation {
  name = "aterm-2.0.5";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/aterm/aterm-2.0.5.tar.gz;
    md5 = "68aefb0c10b2ab876b8d3c0b2d0cdb1b";
  };
  stdenv = stdenv;
}
