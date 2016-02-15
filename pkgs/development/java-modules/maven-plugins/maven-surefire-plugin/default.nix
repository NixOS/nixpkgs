{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenSurefireGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/plugins/maven-compiler-plugin/;
      description = "The Surefire Plugin is used during the test phase of the build lifecycle to execute the unit tests of an application";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenSurefire243 = mavenSurefireGen {
    name = "maven-surefire-plugin-2.4.3";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/surefire/tags/surefire-2.4.3/maven-surefire-plugin/";
      rev = 1724719;
      sha256 = "0f07rwfwb67dwywvfsd77qgyn3pafl1hm010j9wp3sy0ckyl13pm";
    };
    mavenDeps = [ surefireParent243 ];
    m2Path = "/org/apache/maven/plugins/maven-surefire-plugin/2.4.3";
  };
}
