{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenCompilerGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-compiler-plugin/;
      description = "The Compiler Plugin is used to compile the sources of your project.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenCompiler202 = mavenCompilerGen {
    name = "maven-compiler-plugin-2.0.2";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-compiler-plugin-2.0.2/";
      rev = 1724719;
      sha256 = "18klzifbj6kkrj0a181hzp6j4kgfgh7paqla5h79l285dkr7i7sk";
    };
    mavenDeps = [ bootstrapMavenClean25Jar bootstrapMavenCompiler31Jar bootstrapMavenResources26Jar apacheParent3 mavenParent5 mavenPlugin32 mavenPlugins8 ];
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/2.0.2";
  };

  mavenCompiler21 = mavenCompilerGen {
    name = "maven-compiler-plugin-2.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-compiler-plugin-2.1/";
      rev = 1724719;
      sha256 = "1z2hmayxyj79a1g16y079lp1dmd434x6rn7jcw5k5sysqnr00irf";
    };
    mavenDeps = [ bootstrapMavenClean23Jar bootstrapMavenCompiler202Jar bootstrapMavenEnforcer10beta1Jar bootstrapMavenPlugin251Jar bootstrapMavenRemoteResources10Jar bootstrapMavenResources23Jar apacheParent6 mavenParent15 mavenPlugins16 mavenSurefire243 ];
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/2.1";
  };

  mavenCompiler232 = mavenCompilerGen {
    name = "maven-compiler-plugin-2.3.2";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-compiler-plugin-2.3.2/";
      rev = 1724719;
      sha256 = "14lqkj1y13m73x91x7gbzmzrnjvd3j6j5pxlcjbba8v4nayxbz9i";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenEnforcer10Jar bootstrapMavenPlugin26Jar bootstrapMavenRemoteResources11Jar bootstrapMavenResources243Jar apacheParent9 mavenCompiler21 mavenParent16 mavenPlugins18 ];
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/2.3.2";
  };

  mavenCompiler31 = mavenCompilerGen {
    name = "maven-compiler-plugin-3.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/plugins/tags/maven-compiler-plugin-3.1/";
      rev = 1724719;
      sha256 = "1zg6f41rkwh873v9sqifmgc3n8j4higk3fwipyhpks3nfkk01q21";
    };
    mavenDeps = [ apacheParent13 mavenParent23 mavenPlugins24 mavenRemoteResources14 ];
    m2Path = "/org/apache/maven/plugins/maven-compiler-plugin/3.1";
  };
}
