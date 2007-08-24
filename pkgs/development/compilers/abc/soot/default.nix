{stdenv, fetchurl, apacheAnt, polyglot, jasmin}:

stdenv.mkDerivation {
  name = "soot-dev-20060422015512";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://abc.comlab.ox.ac.uk/dists/1.2.0/files/soot-dev-20060422015512.tar.gz;
    md5 = "20dae3e31215b7ec88e3ff32a107d713";
  };

  inherit polyglot jasmin;
  buildInputs = [apacheAnt];
}
