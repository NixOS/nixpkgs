{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenSiteGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-site-plugin/;
      description = "The Site Plugin is used to generate a site for the project. The generated site also includes the project's reports that were configured in the POM.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenSite30beta3 = mavenSiteGen {
    name = "maven-site-plugin-3.0-beta-3";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-site-plugin-3.0-beta-3/";
      rev = 1724719;
      sha256 = "0q4sm09vgvavf2ylhdsw9bn9ihmi5l1wv0hz9n8riiar5g0w960a";
    };
    mavenDeps = [ apacheParent6 apacheParent9 mavenParent13 mavenParent16 mavenPlugins14 mavenPlugins18 mavenRemoteResources11Pom mavenRemoteResources11Jar ];
    m2Path = "/org/apache/maven/plugins/maven-site-plugin/3.0-beta-3";
  };
}
