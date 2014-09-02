# is a pretty good interface for calling rubygems
#
# since there are so many rubygems, and we don't want to manage them all,
# proposed design pattern is keep your gem dependencies in a local file
# (hopefully managed with nix-bundle)
#
# use rubyLibs.importGems to call the local file, which has access to all
# the stuff in here

{ ruby, callPackage, pkgs }:

let
  lib = ruby.stdenv.lib;
  patchGemsWith = gems: patches:
    lib.mapAttrs (gem: drv:
      if patches ? "${gem}"
        then lib.overrideDerivation drv (oldAttrs:
          if oldAttrs ? dontPatch && !(oldAttrs.dontPatch == false || oldAttrs.dontPatch == null) then {}
          else patches."${gem}")
        else drv) gems;
selfPre = rec {
  buildRubyGem = callPackage ./gem.nix { inherit ruby rake; };

  # import an attrset full of gems, then override badly behaved ones
  importGems = file: args:
    let
      patches = callPackage ./patches.nix { inherit ruby; self = builtGems; };
      preBuilt = callPackage file ({ inherit buildRubyGem; self = builtGems; } // args);
      builtGems = self // patchGemsWith preBuilt patches;
    in builtGems;

  ##################################################################
  # stuff EVERYONE needs
  ##################################################################

  bundler = buildRubyGem {
    name = "bundler-1.6.5";
    sha256 = "1s4x0f5by9xs2y24jk6krq5ky7ffkzmxgr4z1nhdykdmpsi2zd0l";
    dontPatchShebangs = 1;
    checkPhase = ":";
  };

  rake = buildRubyGem {
    name = "rake-10.3.2";
    sha256 = "0nvpkjrpsk8xxnij2wd1cdn6arja9q11sxx4aq4fz18bc6fss15m";
    gemPath = [ bundler ];
    checkPhase = ":";
  };


  ##################################################################
  # common dependencies
  ##################################################################

  diff_lcs = buildRubyGem {
    name = "diff-lcs-1.2.5";
    sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    doCheck = false; # check depends on rspec!
  };

  json = buildRubyGem {
    name = "json-1.8.1";
    sha256 = "0002bsycvizvkmk1jyv8px1hskk6wrjfk4f7x5byi8gxm6zzn6wn";
  };

  rspec = rspec_3_0;

  rspec_3_0 = buildRubyGem {
    name = "rspec-3.0.0";
    sha256 = "1x94vk8dlk57clqlyb741y5bsmidp8131wyrb1vh00hi5mdb5szy";
    gemPath = [ diff_lcs rspec_core rspec_expectations rspec_mocks rspec_support ];
  };

  rspec_2_14 = buildRubyGem {
    name = "rspec-2.14.1";
    sha256 = "134y4wzk1prninb5a0bhxgm30kqfzl8dg06af4js5ylnhv2wd7sg";
  };

  rspec_core = buildRubyGem {
    name = "rspec-core-3.0.3";
    sha256 = "0395m5rfpbh87wm3mx549zvm190gikpzyld0xhlr55qwzp6ny97m";
    gemPath = [ rspec_support ];
  };

  rspec_expectations = buildRubyGem {
    name = "rspec-expectations-3.0.3";
    sha256 = "1mzp3v5r7qy28q8x6dkdib9ymwrxxz81jiq9vfr94jxbmy8rkhn0";
    gemPath = [ diff_lcs rspec_support ];
  };

  rspec_mocks = buildRubyGem {
    name = "rspec-mocks-3.0.3";
    sha256 = "0svc5wq8k4w8iamj2r7xw4xwhfczcj09s0ps9wz1mmgy9cvn1lj6";
    gemPath = [ rspec_support ];
  };

  rspec_support = buildRubyGem {
    name = "rspec-support-3.0.3";
    sha256 = "06lxzc4i3cbkm3qc5sdqcg665cyq9hnmmy0qkn355vy4s4vch94l";
  };

  terminal_notifier = buildRubyGem {
    name = "terminal-notifier-1.6.1";
    sha256 = "0j14sblviiypzc9vb508ldd78winba4vhnm9nhg3zpq07p3528g7";
  };

  dotenv_deployment = buildRubyGem {
    name = "dotenv-deployment-0.0.2";
    sha256 = "1ad66jq9a09qq1js8wsyil97018s7y6x0vzji0dy34gh65sbjz8c";
  };

  dotenv = buildRubyGem {
    name = "dotenv-0.11.1";
    gemPath = [ dotenv_deployment ];
    sha256 = "09z0y0d6bks7i0sqvd8szfqj9i1kkj01anzly7shi83b3gxhrq9m";
  };

  libv8 = buildRubyGem {
    name = "libv8-3.16.14.3";
    sha256 = "1arjjbmr9zxkyv6pdrihsz1p5cadzmx8308vgfvrhm380ccgridm";
  };

  mini_portile = buildRubyGem {
    name = "mini_portile-0.6.0";
    sha256 = "09kcn4g63xrdirgwxgjikqg976rr723bkc9bxfr29pk22cj3wavn";
  };

  nokogiri = buildRubyGem {
    name = "nokogiri-1.6.3.1";
    sha256 = "11958hlfd8i3i9y0wk1b6ck9x0j95l4zdbbixmdnnh1r8ijilxli";
    gemPath = [ mini_portile ];
  };

  pg = buildRubyGem {
    name = "pg-0.17.1";
    sha256 = "19hhlq5cp0cgm9b8daxjn8rkk8fq7bxxv1gd43l2hk0qgy7kx4z7";
  };

  ref = buildRubyGem {
    name = "ref-1.0.5";
    sha256 = "19qgpsfszwc2sfh6wixgky5agn831qq8ap854i1jqqhy1zsci3la";
  };

  therubyracer = buildRubyGem {
    name = "therubyracer-0.12.1";
    sha256 = "106fqimqyaalh7p6czbl5m2j69z8gv7cm10mjb8bbb2p2vlmqmi6";
    gemPath = [ self.libv8 self.ref ];
  };
};
  # TODO: refactor mutual recursion here
  # it looks a lot like the importGems function above, but it's too late at night
  # to write a more generic version
  boringPatches = callPackage ./patches.nix { inherit ruby self; };
  self = patchGemsWith selfPre boringPatches;
in self
