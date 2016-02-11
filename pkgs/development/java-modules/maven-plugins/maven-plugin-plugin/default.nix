{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenPluginGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = http://maven.apache.org/plugin-tools/maven-plugin-plugin/;
      description = "The Maven Plugin Plugin is used to create a Maven plugin descriptor for any Mojo's found in the source tree, to include in the JAR. It is also used to generate report files for the Mojos as well as for updating the plugin registry, the artifact metadata and generating a generic help goal.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenPlugin251 = mavenPluginGen {
    name = "maven-plugin-plugin-2.5.1";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-2.5.1/maven-plugin-plugin/";
      rev = 1724719;
      sha256 = "0yrq6q4ckjfp310ki7dq8795f3hp21mjm02vh8iyv3xcfsnf1l9y";
    };
    mavenDeps = [ bootstrapMavenRemoteResources10Jar apacheParent6 mavenEnforcer10beta1 mavenParent13 mavenPlugins14 ];
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.5.1";
  };

  mavenPlugin26 = mavenPluginGen {
    name = "maven-plugin-plugin-2.6";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-2.6/maven-plugin-plugin/";
      rev = 1724719;
      sha256 = "12hawd6hniwn7k4yx5k425p2039fg4mb04lw499yx9i2yf6pbb99";
    };
    mavenDeps = [ apacheParent9 bootstrapMavenEnforcer10Jar bootstrapMavenRemoteResources11Jar mavenParent16 mavenPlugin251 mavenPlugins17 ];
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.6";
  };
}
