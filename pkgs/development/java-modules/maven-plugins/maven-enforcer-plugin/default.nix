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

  mavenEnforcer101 = mavenEnforcerGen {
    name = "maven-enforcer-plugin-1.0.1";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/enforcer/tags/1.0.1/";
      rev = 1724719;
      sha256 = "1j2v6ib0528kc9yzd5v0brza610ck3hi838p6g80f8mqzdxv9wp9";
    };
    mavenDeps = [ apacheParent6 apacheParent9 mavenClean241Jar mavenClean241Pom mavenParent13 mavenParent16 mavenParent19 mavenPlugins14 mavenPlugins18 mavenRemoteResources11Jar mavenRemoteResources11Pom ];
    m2Path = "/org/apache/maven/plugins/maven-enforcer-plugin/1.0.1";
  };
}
