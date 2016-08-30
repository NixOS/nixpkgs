{ stdenv, fetchsvn, mavenbuild, fetchurl, fetchmaven, pkgs }:

with pkgs.mavenPlugins;
with pkgs.javaPackages;
with import ./poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  mavenArchiverGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = https://maven.apache.org/shared/maven-archiver/;
      description = "The Maven Archiver is mainly used by plugins to handle packaging.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenArchiver241 = mavenArchiverGen {
    name = "maven-archiver-2.4.1";
    src = fetchsvn {
      url = "https://svn.apache.org/repos/asf/maven/shared/tags/maven-archiver-2.4.1/";
      rev = 1724719;
      sha256 = "1irxgz6amxq1f5q6w7lq77ay6yc0g1lr9ys8vy7xhaaxrj3c7875";
    };
    mavenDeps = [ bootstrapMavenClean241Jar bootstrapMavenCompiler232Jar bootstrapMavenInstall231Jar bootstrapMavenJar231Jar bootstrapMavenRemoteResources11Jar bootstrapMavenResources243Jar bootstrapMavenSurefire272Jar apacheParent9 mavenArtifact206 mavenModel206 mavenParent16 mavenProject206 mavenShared15 ];
    m2Path = "/org/apache/maven/maven-archiver/2.4.1";
  };
}
