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

  mavenClean25 = mavenCleanGen {
    name = "maven-clean-plugin-2.5";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/plugins/tags/maven-clean-plugin-2.5/";
      rev = 1724719;
      sha256 = "1cq1cy6jwc89k3wr3gnpvgxh8rvslssk5bm28wbb1i5cydfk6rid";
    };
    mavenDeps = [  apacheParent10 mavenParent21 mavenPlugins22 mavenRemoteResources121Jar ];
    m2Path = "/org/apache/maven/plugins/maven-clean-plugin/2.5";
  };
}
