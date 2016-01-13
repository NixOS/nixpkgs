{ stdenv, fetchsvn, fetchurl, fetchmaven, mavenbuild, pkgs }:

with pkgs.mavenPlugins;
with import ./poms.nix { inherit fetchurl; inherit fetchmaven; };

let
  version = "2.2";
in mavenbuild rec {
  name = "commons-io-${version}";

  src = fetchsvn {
    url = "http://svn.apache.org/repos/asf/commons/proper/io/tags/${version}/";
    rev = 1723881;
    sha256 = "19yj3wwrb8jkfxvy2c0y84aj70gvrd5k664yxzs66xd64is4nz27";
  };

  mavenDeps = [ apacheCommonsParent24 apacheParent9 mavenRemoteResources121 ];

  m2Path = "/org/apache/commons/commons-io/2.2";

  meta = {
    homepage = http://commons.apache.org/proper/commons-io/;
    description = "Commons IO is a library of utilities to assist with developing IO functionality.";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers;
      [ nequissimus ];
  };
}

