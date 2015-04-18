{ ruby, bundlerEnv }:

bundlerEnv {
  name = "bundix";
  inherit ruby;
  gemset = ./gemset.nix;
  gemfile = ./Gemfile;
  lockfile = ./Gemfile.lock;
}
