{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenArtifactGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/ref/3.3.9/maven-artifact/;
      description = "Maven Artifact classes, providing Artifact interface";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenArtifact206 = fetchmaven { # Cannot find source for < 2.2.0
    version = "2.0.6";
    name = "maven-artifact-2.0.6";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/maven-artifact/2.0.6/maven-artifact-2.0.6.jar";
      sha256 = "1diqybzi8sif37pbc99896xpdfff58m1cbjl3cffrpzh1akjjmpl";
    };
    m2Path = "/org/apache/maven/maven-artifact/2.0.6";
    m2File = "maven-artifact-2.0.6.jar";
  };
}
