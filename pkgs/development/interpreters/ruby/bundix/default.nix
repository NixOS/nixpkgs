{ buildRubyGem, lib, bundler, ruby, nix, nix-prefetch-scripts }:

buildRubyGem rec {
  inherit ruby;

  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "2.0.4";

  sha256 = "0i7fdxi6w29yxnblpckczazb79m5x03hja8sfnabndg4yjc868qs";

  buildInputs = [bundler];

  postInstall = ''
    gem_root=$GEM_HOME/gems/${gemName}-${version}
    sed \
      -e 's|NIX_INSTANTIATE =.*|NIX_INSTANTIATE = "${nix}/bin/nix-instantiate"|' \
      -i $gem_root/lib/bundix.rb
    sed \
      -e 's|NIX_HASH =.*|NIX_HASH = "${nix}/bin/nix-hash"|' \
      -i $gem_root/lib/bundix.rb
    sed \
      -e 's|NIX_PREFETCH_URL =.*|NIX_PREFETCH_URL = "${nix}/bin/nix-prefetch-url"|' \
      -i $gem_root/lib/bundix.rb
    sed \
      -e 's|NIX_PREFETCH_GIT =.*|NIX_PREFETCH_GIT = "${nix-prefetch-scripts}/bin/nix-prefetch-git"|' \
      -i $gem_root/lib/bundix.rb
  '';

  meta = {
    inherit version;
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = "https://github.com/manveru/bundix";
    license = "MIT";
    maintainers = with lib.maintainers; [ manveru zimbatm ];
    platforms = lib.platforms.all;
  };
}
