{ stdenv, pkgs, mavenbuild }:

with pkgs.javaPackages;

rec {
  mavenHelloRec = { mavenDeps, sha512, version, skipTests }: mavenbuild rec {
    inherit mavenDeps sha512 version skipTests;

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

  mavenHello_1_1 = mavenHelloRec {
    mavenDeps = [ junit_4_12 ];
    sha512 = "3dhgl5z3nzqskjjcggrjyz37r20b0m5vhfzbx382qyqcy4d2jdhkl7v1ajhcg8vkz0qdzq85k09w5is81hybv8sd09h3hgb3rrigdaq";
    version = "1.1";
    skipTests = false;
  };
}
