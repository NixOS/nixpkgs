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

  mavenSite22 = mavenSiteGen {
    name = "maven-site-plugin-2.2";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-site-plugin-2.2/";
      rev = 1724719;
      sha256 = "0y3zgfpzvn5f633nanngn3v4g02gys2avx8hpx6q7v26ml4b7zh5";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenCompiler232Jar bootstrapMavenEnforcer10Jar bootstrapMavenPlugin26Jar bootstrapMavenRemoteResources11Jar bootstrapMavenResources243Jar bootstrapMavenSurefire272Jar apacheParent9 mavenJar231 mavenParent16 mavenPlugins18 ];
    m2Path = "/org/apache/maven/plugins/maven-site-plugin/2.2";
  };

  mavenSite30beta3 = mavenSiteGen {
    name = "maven-site-plugin-3.0-beta-3";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-site-plugin-3.0-beta-3/";
      rev = 1724719;
      sha256 = "0q4sm09vgvavf2ylhdsw9bn9ihmi5l1wv0hz9n8riiar5g0w960a";
    };
    mavenDeps = [ apacheParent6 apacheParent7 apacheParent9 bootstrapMavenEnforcer10Jar bootstrapMavenEnforcer10Pom mavenEnforcerParent10Pom mavenParent13 mavenParent16 mavenParent17 mavenPlugins14 mavenPlugins18 mavenPlugin26 bootstrapMavenRemoteResources11Pom bootstrapMavenRemoteResources11Jar ];
    m2Path = "/org/apache/maven/plugins/maven-site-plugin/3.0-beta-3";
  };

  mavenSite31 = mavenSiteGen {
    name = "maven-site-plugin-3.1";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-site-plugin-3.1/";
      rev = 1724719;
      sha256 = "0p245nwwgsnmmqrfb62bhqg01nnz4ig1jr275sslyykhx04qwf5v";
    };
    mavenDeps = [ bootstrapMavenEnforcer101Jar bootstrapMavenPlugin28Jar bootstrapMavenRemoteResources121Jar apacheParent10 mavenParent21 mavenPlugins22 plexusComponentMetadata154 ];
    m2Path = "/org/apache/maven/plugins/maven-site-plugin/3.1";
  };
}
