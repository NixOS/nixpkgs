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

  mavenPlugin243 = mavenPluginGen {
    name = "maven-plugin-plugin-2.4.3";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-2.4.3/maven-plugin-plugin/";
      rev = 1724719;
      sha256 = "0yx91zi781327jx8vlhc330496rjii8lhsaf90chdfply1hz64ma";
    };
    mavenDeps = [ apacheParent4 mavenParent8 mavenPlugins11 mavenRemoteResources10beta2 ];
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.4.3";
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

  mavenPlugin27 = mavenPluginGen {
    name = "maven-plugin-plugin-2.7";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-2.7/maven-plugin-plugin/";
      rev = 1724719;
      sha256 = "16jbj29f4q7z83664qn5l1z8ix85srgpsf6kxrs7fdhz6dybx4fn";
    };
    mavenDeps = [ bootstrapMavenEnforcer10Jar bootstrapMavenPlugin26Jar bootstrapMavenRemoteResources11Jar apacheParent9 mavenParent16 mavenPlugins18 modelloMavenPlugin141 ];
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.7";
  };

  mavenPlugin28 = mavenPluginGen {
    name = "maven-plugin-plugin-2.8";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-2.8/maven-plugin-plugin/";
      rev = 1724719;
      sha256 = "1f7sysy7zng22mz4rqj1s4dm0viidlnj6adcc5rg37drqa7yn4wn";
    };
    mavenDeps = [ bootstrapMavenEnforcer10Jar bootstrapMavenRemoteResources11Jar apacheParent9 mavenParent19 mavenPlugin27 mavenPlugins20 ];
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/2.8";
  };

  mavenPlugin31 = mavenPluginGen {
    name = "maven-plugin-plugin-3.1";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-3.1/maven-plugin-plugin/";
      rev = 1724719;
      sha256 = "1g25r101szzj3ac8zg44jsx6pm4jip592zq0kc34y7qjgn98wmw0";
    };
    mavenDeps = [ bootstrapMavenRemoteResources121Jar apacheParent10 mavenParent21 mavenPluginTools31 mavenSite31 ];
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/3.1";
  };

  mavenPlugin32 = mavenPluginGen {
    name = "maven-plugin-plugin-3.2";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugin-tools/tags/maven-plugin-tools-3.2/maven-plugin-plugin/";
      rev = 1724719;
      sha256 = "1dv59q4i6rf7yd70zqzl5k0k9dd0rd7g4jimhaasvd5iz9jy2lpc";
    };
    mavenDeps = [ bootstrapMavenClean25Jar bootstrapMavenEnforcer101Jar bootstrapMavenPlugin31Jar bootstrapMavenRemoteResources13Jar bootstrapMavenSite31Jar bootstrapModelloMaven141Jar apacheParent11 mavenParent22 mavenPluginTools32 mavenResources25 ];
    m2Path = "/org/apache/maven/plugins/maven-plugin-plugin/3.2";
  };
}
