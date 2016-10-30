{ stdenv, pkgs, mavenbuild }:

with pkgs.javaPackages;

rec {
  junitGen = { mavenDeps, sha512, version }: mavenbuild rec {
    inherit mavenDeps sha512 version;

    name = "junit-${version}";
    src = pkgs.fetchFromGitHub {
      inherit sha512;
      owner = "junit-team";
      repo = "junit4";
      rev = "r${version}";
    };
    m2Path = "/junit/junit/${version}";

    meta = {
      homepage = http://junit.org/junit4/;
      description = "Simple framework to write repeatable tests. It is an instance of the xUnit architecture for unit testing frameworks";
      license = stdenv.lib.licenses.epl10;
      platforms = stdenv.lib.platforms.all;
      maintainers = with stdenv.lib.maintainers;
        [ nequissimus ];
    };
  };

  junit_4_12 = junitGen {
    mavenDeps = [ mavenPlugins.animalSniffer_1_11 hamcrestCore_1_3 plexusUtils_1_1 ] ++ mavenPlugins.mavenDefault;
    sha512 = "0bbldnf37jl855s1pdx2a518ivfifv75189vsbpylnj8530vnf8z6b2dglkcbcjgr22lp1s4m1nnplz5dmka9sr7vj055p88k27kqw9";
    version = "4.12";
  };
}
