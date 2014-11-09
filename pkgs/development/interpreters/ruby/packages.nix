{ ruby, rubygemsFun, callPackage }:

{
  # Nix utilities
  gemFixes = callPackage ../development/interpreters/ruby/fixes.nix { };
  buildRubyGem = callPackage ../development/interpreters/ruby/gem.nix { inherit ruby; };
  loadRubyEnv = callPackage ../development/interpreters/ruby/load-ruby-env.nix { inherit ruby; };

  # Gems
  rubygems = rubygemsFun ruby;
}
