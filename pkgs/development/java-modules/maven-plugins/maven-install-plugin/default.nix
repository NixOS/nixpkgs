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

  mavenInstall23 = mavenInstallGen {
    name = "maven-install-plugin-2.3";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-install-plugin-2.3/";
      rev = 1724719;
      sha256 = "1m2snlpkn962ab77sxpamc3y4b4ib441h166xgzh8pq60m90ddya";
    };
    mavenDeps = [ bootstrapMavenClean23Jar bootstrapMavenEnforcer10alpha4Jar bootstrapMavenPlugin243Jar bootstrapMavenRemoteResources10Jar bootstrapMavenResources23Jar apacheParent5 mavenCompiler202 mavenParent11 mavenPlugins13 ];
    m2Path = "/org/apache/maven/plugins/maven-install-plugin/2.3";
  };

  mavenInstall231 = mavenInstallGen {
    name = "maven-install-plugin-2.3.1";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-install-plugin-2.3.1/";
      rev = 1724719;
      sha256 = "0xi565jf7jv9iymna0ps8rqgswfb4fx3fmf9smwd0ynl0c8050q2";
    };
    mavenDeps = [ apacheParent6 apacheParent9 bootstrapMavenEnforcer10Pom mavenEnforcer10 mavenParent13 mavenParent16 mavenPlugins14 mavenPlugins18 bootstrapMavenRemoteResources11Pom bootstrapMavenRemoteResources11Jar ];
    m2Path = "/org/apache/maven/plugins/maven-install-plugin/2.3.1";
  };
}
