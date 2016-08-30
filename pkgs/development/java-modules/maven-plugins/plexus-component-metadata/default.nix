{ stdenv, fetchgit, mavenbuild, fetchmaven, fetchurl, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  plexusComponentMetadataGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = http://codehaus-plexus.github.io/plexus-containers/plexus-component-metadata/;
      description = "A Maven plugin to generate Plexus descriptors from source tags and class annotations.";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  plexusComponentMetadata154 = plexusComponentMetadataGen {
    name = "plexus-component-metadata-1.5.4";
    src = fetchgit {
      url = "git://github.com/codehaus-plexus/plexus-containers.git";
      rev = "refs/tags/plexus-containers-1.5.4";
      sha256 = "1vkx2niig1zfkskifflj7y2rl6v4pajqp8h434jaxv33d45qpvci";
    };
    mavenDeps = [ bootstrapMavenClean24Jar mavenInstall23 plexusParent205 ];
    m2Path = "/org/codehaus/plexus/plexus-component-metadata/1.5.4";
  };
}
