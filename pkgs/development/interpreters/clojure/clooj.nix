{stdenv, fetchurl}:

let
  jar = fetchurl {
    url = https://github.com/downloads/arthuredelstein/clooj/clooj-0.1.36-STANDALONE.jar;
    sha256 = "173c66c0aade3ae5d21622f629e60efa51a03ad83c087b02c25e806c5b7f838c";
  };
in

stdenv.mkDerivation {
  name = "clooj-0.1.32";

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/lib/java
    ln -s ${jar} $out/lib/java/clooj.jar
  '';

  meta = {
    description = "clooj, a lightweight IDE for clojure";
    homepage = https://github.com/arthuredelstein/clooj;
    license = stdenv.lib.licenses.bsd3;
  };
}