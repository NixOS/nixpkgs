{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with pkgs.javaPackages;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenJarGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-jar-plugin/;
      description = "This plugin provides the capability to build jars";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenJar231 = mavenJarGen {
    name = "maven-jar-plugin-2.3.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-jar-plugin-2.3.1/";
      rev = 1724719;
      sha256 = "1zm4sh9j0ghnng8lyc7qmhi0p7jf6ns8zvmrdfmq9r5s91xgbbgz";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenCompiler232Jar bootstrapMavenEnforcer10Jar bootstrapMavenInstall231Jar bootstrapMavenJar231Jar bootstrapMavenPlugin26Jar bootstrapMavenRemoteResources11Jar bootstrapMavenResources243Jar bootstrapMavenSurefire272Jar apacheParent9 mavenArchiver241 mavenArtifact206 mavenModel206 mavenParent16 mavenPluginApi206 mavenProject206 mavenPlugins18 ];
    m2Path = "/org/apache/maven/plugins/maven-jar-plugin/2.3.1";
  };

  mavenJar24 = mavenJarGen {
    name = "maven-jar-plugin-2.4";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-jar-plugin-2.4/";
      rev = 1724719;
      sha256 = "0s3xs4qjlnvfw7q3s6b152lhqvr69698xdh7pzi4dirkhlrfn063";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenCompiler232Jar bootstrapMavenEnforcer101Jar bootstrapMavenPlugin28Jar bootstrapMavenRemoteResources121Jar bootstrapMavenResources25Jar apacheParent10 mavenParent21 mavenPlugins22 mavenSurefire29 ];
    m2Path = "/org/apache/maven/plugins/maven-jar-plugin/2.4";
  };
}
