{ pkgs }:

{ buildInputs ? [], generated, ... } @ attrs:

let
  # Fetches the bower packages. `generated` should be the result of a
  # `bower2nix` command.
  bowerPackages = import generated {
    inherit (pkgs) buildEnv fetchbower;
  };

in pkgs.stdenv.mkDerivation (
  attrs
  //
  {
    name = "bower_components-" + attrs.name;

    inherit bowerPackages;

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup

      # The project's bower.json is required
      cp $src/bower.json .

      # Dereference symlinks -- bower doesn't like them
      cp  --recursive --reflink=auto       \
          --dereference --no-preserve=mode \
          $bowerPackages bc

      # Bower install in offline mode -- links together the fetched
      # bower packages.
      HOME=$PWD bower \
          --config.storage.packages=bc/packages \
          --config.storage.registry=bc/registry \
          --offline install

      # Sets up a single bower_components directory within
      # the output derivation.
      mkdir -p $out
      mv bower_components $out
    '';

    buildInputs = buildInputs ++ [
      pkgs.git
      pkgs.nodePackages.bower
    ];
  }
)
