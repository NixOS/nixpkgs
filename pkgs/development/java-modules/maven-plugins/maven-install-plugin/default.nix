{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenInstallGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-install-plugin/;
      description = "The Install Plugin is used during the install phase to add artifact(s) to the local repository. The Install Plugin uses the information in the POM (groupId, artifactId, version) to determine the proper location for the artifact within the local repository.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenInstall231 = mavenInstallGen {
    name = "maven-install-plugin-2.3.1";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-install-plugin-2.3.1/";
      rev = 1724719;
      sha256 = "0xi565jf7jv9iymna0ps8rqgswfb4fx3fmf9smwd0ynl0c8050q2";
    };
    mavenDeps = [ apacheParent6 apacheParent9 mavenEnforcer10 mavenParent13 mavenParent16 mavenPlugins14 mavenPlugins18 mavenRemoteResources11Pom mavenRemoteResources11Jar ];
    m2Path = "/org/apache/maven/plugins/maven-install-plugin/2.3.1";
  };
}
