{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenCleanGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-clean-plugin/;
      description = "The Clean Plugin is used when you want to remove files generated at build-time in a project's directory.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenClean22 = mavenCleanGen {
    name = "maven-clean-plugin-2.2";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-clean-plugin-2.2/";
      rev = 1724719;
      sha256 = "0j01zbrrk7b2qaismgdazmgrcwyyv0ni2cc46awbgal9pcx54bqa";
    };
    mavenDeps = [ bootstrapMavenClean25Jar bootstrapMavenRemoteResources10alpha6Jar apacheParent4 mavenParent7 mavenPlugins10 mavenResources26 ];
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.2";
  };

  mavenClean23 = mavenCleanGen {
    name = "maven-clean-plugin-2.3";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-clean-plugin-2.3/";
      rev = 1724719;
      sha256 = "0cj66xvf72871mcl80k37sc7zmzlrqwj4vygkp9pbn314d514hap";
    };
    mavenDeps = [ bootstrapMavenRemoteResources10Jar bootstrapMavenEnforcer10Jar apacheParent4 mavenEnforcer10alpha4 mavenParent9 mavenPlugins12 ];
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.3";
  };

  mavenClean24 = mavenCleanGen {
    name = "maven-clean-plugin-2.4";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-clean-plugin-2.4/";
      rev = 1724719;
      sha256 = "0a28nx3ys0r13sm0czvlrz5qn87i9vbn4kpxd18n04bfj3yh5vz0";
    };
    mavenDeps = [ bootstrapMavenClean23Jar bootstrapMavenEnforcer10beta1Jar bootstrapMavenPlugin251Jar bootstrapMavenRemoteResources10Jar apacheParent6 mavenParent15 mavenPlugins16 mavenResources23 ];
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.4";
  };

  mavenClean241 = mavenCleanGen {
    name = "maven-clean-plugin-2.4.1";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-clean-plugin-2.4.1/";
      rev = 1724719;
      sha256 = "02hz8659nv9lma9vgrhzlbbg0qjvc52xqsqmhws2wyn089gi8k7y";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenEnforcer10Jar bootstrapMavenPlugin26Jar bootstrapMavenRemoteResources11Jar apacheParent9 mavenParent16 mavenPlugins18 mavenResources243 ];
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.4.1";
  };

  mavenClean25 = mavenCleanGen {
    name = "maven-clean-plugin-2.5";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-clean-plugin-2.5/";
      rev = 1724719;
      sha256 = "1cq1cy6jwc89k3wr3gnpvgxh8rvslssk5bm28wbb1i5cydfk6rid";
    };
    mavenDeps = [ apacheParent9 apacheParent10 mavenEnforcer101 mavenParent19 mavenPlugins19 mavenParent21 mavenPlugins22 bootstrapMavenRemoteResources121Jar bootstrapMavenRemoteResources121Pom ];
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.5";
  };
}
