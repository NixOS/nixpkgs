{ stdenv, fetchsvn, mavenbuild, fetchmaven, fetchurl, pkgs }:

with pkgs.mavenPlugins;
with import ../../poms.nix { inherit fetchurl; inherit fetchmaven; };

rec {
  wagonWebdavGen = { name, src, mavenDeps, m2Path }: mavenbuild rec {
    inherit name src mavenDeps m2Path;

    meta = {
      homepage = http://maven.apache.org/wagon/wagon-providers/wagon-webdav-jackrabbit/;
      description = "This component is an implementation of Wagon provider for WebDAV server access";
      license = stdenv.lib.licenses.asl20;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  wagonWebdav10beta2 = wagonWebdavGen {
    name = "wagon-webdav-1.0-beta-2";
    src = fetchsvn {
      url = "http://svn.apache.org/repos/asf/maven/wagon/tags/wagon-1.0-beta-2/wagon-providers/wagon-webdav/";
      rev = 1723938;
      sha256 = "0x8mpz9kwv1vd7kwz3fy7v8pidws6akcp8pspn69jjayn7g1dkws";
    };
    mavenDeps = [ apacheParent3 apacheParent4 mavenClean25 mavenParent4 wagon10beta2 wagonProviders10beta2 ];
    m2Path = "/org/apache/maven/wagon/wagon-webdav/1.0-beta-2";
  };
}
