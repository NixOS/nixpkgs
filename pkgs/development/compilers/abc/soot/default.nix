{stdenv, fetchurl, apacheAnt, polyglot, jasmin}:

stdenv.mkDerivation {
  name = "soot-dev-20060422015512";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/soot-dev-20060422015512.tar.gz;
    md5 = "20dae3e31215b7ec88e3ff32a107d713";
  };

  inherit polyglot jasmin;
  buildInputs = [apacheAnt];
}
