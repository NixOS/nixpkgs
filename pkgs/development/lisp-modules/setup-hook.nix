"${./setup-hook.sh}"

# dependencies:

# let
  # hook = ./setup-hook.sh;
# in runCommand "asdf-setup-hook.sh" {
  # inherit dependencies;
  # inherit (builtins) storeDir;
# } ''
  # cp ${hook} hook.sh
  # substituteAllInPlace hook.sh
  # mv hook.sh $out
# ''
