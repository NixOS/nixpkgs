{ stdenv, fetchgit, mavenbuild, fetchmaven, fetchurl, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  modelloMavenPluginGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = http://codehaus-plexus.github.io/modello/modello-maven-plugin/;
      description = "This plugin makes use of the Modello project.";
      license = stdenv.lib.licenses.mit;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  modelloMavenPlugin10Alpha15 = modelloMavenPluginGen {
    name = "modello-maven-plugin-1.0-alpha-15";
    src = fetchgit {
      url = "git://github.com/codehaus-plexus/modello.git";
      rev = "refs/tags/modello-1.0-alpha-15";
      sha256 = "01k3lhb354b3b1y7wxizsxrpmygz8v614cj5y2g435ww65yfdwqv";
    };
    mavenDeps = [ wagonWebdav10beta2 ];
    m2Path = "/org/codehaus/modello/modello-maven-plugin/1.0-alpha-15";
  };

  modelloMavenPlugin141 = modelloMavenPluginGen {
    name = "modello-maven-plugin-1.4.1";
    src = fetchgit {
      url = "git://github.com/codehaus-plexus/modello.git";
      rev = "refs/tags/modello-1.4.1";
      sha256 = "0nxdgh98cr353dmr2y09d2wqvbkgihi39rznn7vb75qw9aq7mi5j";
    };
    mavenDeps = [ mavenClean24 ];
    m2Path = "/org/codehaus/modello/modello-maven-plugin/1.4.1";
  };
}
