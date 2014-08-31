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
  buildRubyGem = callPackage ./gem.nix { inherit ruby; };
  lib = ruby.stdenv.lib;

  # A set of gems that everyone needs.
  common = {
    bundler = {
      name = "bundler-1.6.5";
      sha256 = "1s4x0f5by9xs2y24jk6krq5ky7ffkzmxgr4z1nhdykdmpsi2zd0l";
    };

    rake = {
      name = "rake-10.3.2";
      sha256 = "0nvpkjrpsk8xxnij2wd1cdn6arja9q11sxx4aq4fz18bc6fss15m";
      dependencies = [ "bundler" ];
    };
  };

  fixGems = gemset: callPackage ./fixes.nix { inherit buildRubyGem gemset ruby; };

in

(fixGems common) // {
  inherit buildRubyGem;

  # Import an attribute set of gems and apply a set of overrides. Nixpkgs fixes
  # popular gems that don't behave. If you specify your own override for a gem,
  # the one distributed with nixpgks will not be applied.
  #
  # Example:
  #
  #   importGems ./gems.nix (gemset: {
  #     pg = buildRubyGem (gemset.pg // {
  #       buildInputs = [ postgresql ];
  #     });
  #   });
  importGems = file: args:
    let
      # 1. Load set of gem names and versions from a bundix-created expression.
      gemset = callPackage file { };
      # 2. Allow gems to be overriden by providing a derivation yourself.
      config = gemset // (args gemset);
      # 3.
      gems = fixGems config;
    in gems;
}
