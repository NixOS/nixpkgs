{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenModelGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/ref/3.3.9/maven-model/;
      description = "This is strictly the model for Maven POM (Project Object Model), so really just plain objects";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenModel206 = fetchmaven { # Cannot find source for < 2.2.0
    version = "2.0.6";
    name = "maven-model-2.0.6";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/maven-model/2.0.6/maven-model-2.0.6.jar";
      sha256 = "0qk99jkbi1pzjc7kzr3gsz3k0yfq80m7xbh1ffqrz89dhlhbyvdq";
    };
    m2Path = "/org/apache/maven/maven-model/2.0.6";
    m2File = "maven-model-2.0.6.jar";
  };
}
