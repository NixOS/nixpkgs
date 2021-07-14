{ runCommand, postcss-cli }:

let
  inherit (postcss-cli) packageName version;
in

runCommand "${packageName}-tests" { meta.timeout = 60; }
  ''
    # get version of installed program and compare with package version
    claimed_version="$(${postcss-cli}/bin/postcss --version)"
    if [[ "$claimed_version" != "${version}" ]]; then
      echo "Error: program version does not match package version ($claimed_version != ${version})"
      exit 1
    fi

    # run basic help command
    ${postcss-cli}/bin/postcss --help > /dev/null

    # needed for Nix to register the command as successful
    touch $out
  ''
