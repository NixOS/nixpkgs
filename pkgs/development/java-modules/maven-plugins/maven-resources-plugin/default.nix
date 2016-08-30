{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenResourcesGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-resources-plugin/;
      description = "The Resources Plugin handles the copying of project resources to the output directory. There are two different kinds of resources: main resources and test resources. The difference is that the main resources are the resources associated to the main source code while the test resources are associated to the test source code.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenResources23 = mavenResourcesGen {
    name = "maven-resources-plugin-2.3";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-resources-plugin-2.3/";
      rev = 1723938;
      sha256 = "1rcxgifcmmk01y3ra3xk29da1jsziqj66r6garwp34y05af7ascm";
    };
    mavenDeps = [ bootstrapMavenEnforcer10alpha4Jar bootstrapMavenRemoteResources10Jar apacheParent4 mavenParent9 mavenPlugin243 mavenPlugins12 ];
    m2Path = "/org/apache/maven/plugins/maven-resources-plugin/2.3";
  };

  mavenResources243 = mavenResourcesGen {
    name = "maven-resources-plugin-2.4.3";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-resources-plugin-2.4.3/";
      rev = 1723938;
      sha256 = "0d3mz9gr3cppk6gjysiaq427bmjia34i9mkzk1wbf35imjgsil4a";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenEnforcer10Jar bootstrapMavenPlugin26Jar bootstrapMavenRemoteResources11Jar bootstrapMavenResources243Jar apacheParent9 mavenCompiler232 mavenParent16 mavenPlugins18 ];
    m2Path = "/org/apache/maven/plugins/maven-resources-plugin/2.4.3";
  };

  mavenResources25 = mavenResourcesGen {
    name = "maven-resources-plugin-2.5";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-resources-plugin-2.5/";
      rev = 1723938;
      sha256 = "04rgy391qyzy4fqw9r3pbdqij3f3hygxa1sxxyz5jipvs7b14ndp";
    };
    mavenDeps = [ bootstrapMavenEnforcer10Jar bootstrapMavenPlugin27Jar bootstrapMavenRemoteResources11Jar apacheParent9 mavenClean241 mavenParent19 mavenPlugins19 ];
    m2Path = "/org/apache/maven/plugins/maven-resources-plugin/2.5";
  };

  mavenResources26 = mavenResourcesGen {
    name = "maven-resources-plugin-2.6";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-resources-plugin-2.6/";
      rev = 1723938;
      sha256 = "05awkb89kc74bslnqls851idw6shv249pcj287b5g59xkk5bv0si";
    };
    mavenDeps = [ apacheParent11 mavenParent22 mavenPlugins23 mavenRemoteResources13 ];
    m2Path = "/org/apache/maven/plugins/maven-resources-plugin/2.6";
  };
}
