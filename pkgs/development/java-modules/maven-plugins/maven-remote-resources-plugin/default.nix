{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenRemoteResourcesGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-remote-resources-plugin/;
      description = "Retrieve JARs of resources from remote repositories, process those resources, and incorporate them into JARs you build with Maven.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenRemoteResources10alpha6 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.0-alpha-6";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.0-alpha-6/";
      rev = 1723938;
      sha256 = "1ri6bv79hvhdza6b5973gzw149rx611wcjvyvmz5n7ixkz9bplfa";
    };
    mavenDeps = [ apacheParent4 mavenParent5 mavenPlugins8 bootstrapMavenRemoteResources10alpha6Jar modelloMavenPlugin10Alpha15 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.0-alpha-6";
  };

  mavenRemoteResources10beta2 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.0-beta-2";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.0-beta-2/";
      rev = 1723938;
      sha256 = "03ndkaglcr50jh9pj8587q17kjb13nd7097r05mxykh07ap906c1";
    };
    mavenDeps = [ bootstrapMavenClean25Jar bootstrapMavenRemoteResources10alpha6Jar bootstrapMavenResources26Jar bootstrapModelloMaven10alpha15Jar apacheParent4 mavenCompiler31 mavenParent7 mavenPlugins10 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.0-beta-2";
  };

  mavenRemoteResources10 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.0";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.0/";
      rev = 1723938;
      sha256 = "15zqzlmqvwp8w5q4y9jzgilm5jmrm3zr26zb24zxvv16wvj30jkc";
    };
    mavenDeps = [ apacheParent4 mavenParent7 mavenPlugins10 mavenRemoteResources10alpha6 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.0";
  };

  mavenRemoteResources11 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.1/";
      rev = 1723938;
      sha256 = "0y8xq6w9nnssz988pjjnn6xplv694vw8swx80dlcfgmyxl29lsw6";
    };
    mavenDeps = [ apacheParent6 mavenParent13 mavenPlugins14 mavenRemoteResources10 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.1";
  };

  mavenRemoteResources121 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.2.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.2.1/";
      rev = 1723938;
      sha256 = "0f0v5qd4fbfg755dic78gymhqlf6pl7zfqs5d5cvhaagqf2as5j6";
    };
    mavenDeps = [ apacheParent9 mavenParent19 mavenPlugins19 mavenRemoteResources11 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.2.1";
  };

  mavenRemoteResources13 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.3";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.3/";
      rev = 1723938;
      sha256 = "1sl6dl6j2i6yxd11y55164ciq48c6qddjibi3198kpv6h0lr30rv";
    };
    mavenDeps = [ bootstrapMavenRemoteResources121Jar bootstrapMavenEnforcer101Jar apacheParent10 mavenParent21 mavenPlugin28 mavenPlugins22 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.3";
  };

  mavenRemoteResources14 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.4";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.4/";
      rev = 1723938;
      sha256 = "0zhl2mlmsqnmwffwdnc2yyw1s22833vzbj91jq39hjyamc72my45";
    };
    mavenDeps = [ bootstrapMavenEnforcer101Jar bootstrapMavenRemoteResources13Jar bootstrapModelloMaven141Jar apacheParent11 mavenParent22 mavenPlugin31 mavenPlugins23 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.4";
  };
}
