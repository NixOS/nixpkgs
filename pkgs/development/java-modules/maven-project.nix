{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenProjectGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = http://maven.apache.org/;
      description = "This library is used to not only read Maven project object model files, but to assemble inheritence and to retrieve remote models as required";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenProject206 = fetchmaven { # Cannot find source for < 2.2.0
    version = "2.0.6";
    name = "maven-project-2.0.6";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/maven-project/2.0.6/maven-project-2.0.6.jar";
      sha256 = "1581dq92q7pmij7kwi01q52bzqb7ql0g4g74qsj4fyakhxayz4gh";
    };
    m2Path = "/org/apache/maven/maven-project/2.0.6";
    m2File = "maven-project-2.0.6.jar";
  };
}
