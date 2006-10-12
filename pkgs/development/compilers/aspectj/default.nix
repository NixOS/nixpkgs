{stdenv, fetchurl, jre}:

stdenv.mkDerivation {
  name = "aspectj-1.5.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/aspectj-1.5.2.jar;
    md5 = "64245d451549325147e3ca1ec4c9e57c";
  };

  inherit jre;
  buildInputs = [jre];
}
