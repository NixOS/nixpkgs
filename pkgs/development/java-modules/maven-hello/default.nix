{ stdenv, pkgs, mavenbuild }:

with pkgs.javaPackages;

rec {
  mavenHelloRec = { mavenDeps, sha512, version }: mavenbuild rec {
    inherit mavenDeps sha512 version;

    name = "maven-hello-${version}";
    src = pkgs.fetchFromGitHub {
      inherit sha512;
      owner = "NeQuissimus";
      repo = "maven-hello";
      rev = "v${version}";
    };
    m2Path = "/com/nequissimus/maven-hello/${version}";

    meta = {
      homepage = http://github.com/NeQuissimus/maven-hello/;
      description = "Maven Hello World";
      license = stdenv.lib.licenses.unlicense;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenHello_1_0 = mavenHelloRec {
    mavenDeps = [];
    sha512 = "3kv5z1i02wfb0l5x3phbsk3qb3wky05sqn4v3y4cx56slqfp9z8j76vnh8v45ydgskwl2vs9xjx6ai8991mzb5ikvl3vdgmrj1j17p2";
    version = "1.0";
  };
}
