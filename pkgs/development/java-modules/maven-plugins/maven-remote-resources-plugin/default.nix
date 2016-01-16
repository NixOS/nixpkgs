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

  mavenRemoteResourcesAlpha6 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.0-alpha-6";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.0-alpha-6/";
      rev = 1723938;
      sha256 = "1ri6bv79hvhdza6b5973gzw149rx611wcjvyvmz5n7ixkz9bplfa";
    };
    mavenDeps = [ apacheParent4 mavenParent5 mavenPlugins8 mavenRemoteResourcesAlpha6Jar modelloMavenPlugin10Alpha15 ];
    m2Path = "/org/apache/maven/plugins/maven-remote-resources-plugin/1.0-alpha-6";
  };

  mavenRemoteResources10 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.0";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.0/";
      rev = 1723938;
      sha256 = "15zqzlmqvwp8w5q4y9jzgilm5jmrm3zr26zb24zxvv16wvj30jkc";
    };
    mavenDeps = [ apacheParent4 mavenParent7 mavenPlugins10 mavenRemoteResourcesAlpha6 ];
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
}

