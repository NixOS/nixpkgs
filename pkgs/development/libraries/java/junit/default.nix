{ stdenv, fetchurl }:

let

  junit = fetchurl {
    url = http://search.maven.org/remotecontent?filepath=junit/junit/4.11/junit-4.11.jar;
    sha256 = "1zh6klzv8w30dx7jg6pkhllk4587av4znflzhxz8x97c7rhf3a4h";
  };

  hamcrest = fetchurl {
    url = http://search.maven.org/remotecontent?filepath=org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar;
    sha256 = "1sfqqi8p5957hs9yik44an3lwpv8ln2a6sh9gbgli4vkx68yzzb6";
  };

in

stdenv.mkDerivation {
  name = "junit-4.11";

  unpackPhase = "true";

  installPhase =
    ''
      mkdir -p $out/share/java
      ln -s ${junit} $out/share/java/junit.jar
      ln -s ${hamcrest} $out/share/java/hamcrest-core.jar
    '';

  meta = {
    homepage = http://www.junit.org/;
    description = "A framework for repeatable tests in Java";
    license = stdenv.lib.licenses.epl10;
  };
}
