{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenPluginApiGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = http://maven.apache.org/ref/3.3.9/maven-plugin-api/source-repository.html;
      description = "The API for plugins - composed of goals implemented by Mojos - development";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenPluginApi206 = fetchmaven { # Cannot find source for < 2.2.0
    version = "2.0.6";
    name = "maven-plugin-api-2.0.6";
    src = fetchurl rec {
      url = "https://repo1.maven.org/maven2/org/apache/maven/maven-plugin-api/2.0.6/maven-plugin-api-2.0.6.jar";
      sha256 = "0lsh5qp2psd8xfx3wz342k8frh5hndb32mn5g4qwsp6j72z4pdd1";
    };
    m2Path = "/org/apache/maven/maven-plugin-api/2.0.6";
    m2File = "maven-plugin-api-2.0.6.jar";
  };
}
