{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenEnforcerGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = http://maven.apache.org/enforcer/maven-enforcer-plugin/;
      description = "The Enforcer plugin provides goals to control certain environmental constraints such as Maven version, JDK version and OS family along with many more standard rules and user created rules.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenEnforcer10alpha4 = mavenEnforcerGen {
    name = "maven-enforcer-plugin-1.0-alpha-4";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/enforcer/tags/enforcer-1.0-alpha-4/";
      rev = 1724719;
      sha256 = "0qg5r1b0c7fk5ypvz05m1cnfc4h86mphaj20flf5pwbr1kvglq76";
    };
    mavenDeps = [ bootstrapMavenRemoteResources10Jar apacheParent4 mavenClean22 mavenParent9 ];
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0-alpha-4";
  };

  mavenEnforcer10beta1 = mavenEnforcerGen {
    name = "maven-enforcer-plugin-1.0-beta-1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/enforcer/tags/enforcer-1.0-beta-1/";
      rev = 1724719;
      sha256 = "158f2qsxcncymd80xk5x0whmi34r2fp5m2ln8lp2jj3vm96wy5ra";
    };
    mavenDeps = [ bootstrapMavenRemoteResources10Jar apacheParent5 mavenClean23 mavenParent11 ];
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0-beta-1";
  };

  mavenEnforcer10 = mavenEnforcerGen {
    name = "maven-enforcer-plugin-1.0";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/enforcer/tags/enforcer-1.0/";
      rev = 1724719;
      sha256 = "1ph1qlcxpbrc00cmfc0aqdjv9n4v5qmlswgvk9c4l6fhd7jv8i3d";
    };
    mavenDeps = [ apacheParent6 apacheParent7 mavenParent13 mavenParent17 mavenPlugins14 bootstrapMavenRemoteResources11Jar bootstrapMavenRemoteResources11Pom mavenSite30beta3 ];
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0";
  };

  mavenEnforcer101 = mavenEnforcerGen {
    name = "maven-enforcer-plugin-1.0.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/enforcer/tags/1.0.1/";
      rev = 1724719;
      sha256 = "1j2v6ib0528kc9yzd5v0brza610ck3hi838p6g80f8mqzdxv9wp9";
    };
    mavenDeps = [ apacheParent6 apacheParent9 bootstrapMavenClean241Jar bootstrapMavenClean241Pom mavenInstall231 mavenParent13 mavenParent16 mavenParent19 mavenPlugins14 mavenPlugins18 bootstrapMavenRemoteResources11Jar bootstrapMavenRemoteResources11Pom ];
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0.1";
  };
}
