{ buildRubyGem, lib, bundler, ruby, nix, nix-prefetch-git }:

buildRubyGem rec {
  inherit ruby;

  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "2.0.5";

  sha256 = "0bsynhr44jz6nih0xn7v32h1qvywnb5335ka208gn7jp6bjwabhy";

  buildInputs = [bundler];

  postInstall = ''
    substituteInPlace $GEM_HOME/gems/${gemName}-${version}/lib/bundix.rb \
      --replace \
        "'nix-instantiate'" \
        "'${nix}/bin/nix-instantiate'" \
      --replace \
        "'nix-hash'" \
        "'${nix}/bin/nix-hash'" \
      --replace \
        "'nix-prefetch-url'" \
        "'${nix}/bin/nix-prefetch-url'" \
      --replace \
        "'nix-prefetch-git'" \
        "'${nix-prefetch-git}/bin/nix-prefetch-git'"
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
