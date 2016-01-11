{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven }:

with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenRemoteResourcesGen = { name, src, mavenDeps}: mavenbuild rec {
    inherit name src mavenDeps;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-remote-resources-plugin/;
      description = "Retrieve JARs of resources from remote repositories, process those resources, and incorporate them into JARs you build with Maven.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenRemoteResources10 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.0";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.0/";
      rev = 1723938;
      sha256 = "15zqzlmqvwp8w5q4y9jzgilm5jmrm3zr26zb24zxvv16wvj30jkc";
    };
    mavenDeps = [ apacheParent4 mavenParent7 mavenPlugins10 ];
  };

  mavenRemoteResources11 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.1/";
      rev = 1723938;
      sha256 = "0y8xq6w9nnssz988pjjnn6xplv694vw8swx80dlcfgmyxl29lsw6";
    };
    mavenDeps = [ apacheParent6 mavenParent13 mavenPlugins14 mavenRemoteResources10 ];
  };

  mavenRemoteResources121 = mavenRemoteResourcesGen {
    name = "maven-remote-resources-plugin-1.2.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-remote-resources-plugin-1.2.1/";
      rev = 1723938;
      sha256 = "0f0v5qd4fbfg755dic78gymhqlf6pl7zfqs5d5cvhaagqf2as5j6";
    };
    mavenDeps = [ apacheParent9 mavenParent19 mavenPlugins19 mavenRemoteResources11 ];
  };
}

