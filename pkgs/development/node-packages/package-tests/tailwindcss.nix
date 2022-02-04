{ runCommand, tailwindcss }:

let
  inherit (tailwindcss) packageName version;
in

runCommand "${packageName}-tests" { meta.timeout = 60; }
  ''
    # Ensure CLI runs
    ${tailwindcss}/bin/tailwind --help > /dev/null
    ${tailwindcss}/bin/tailwindcss --help > /dev/null

    # Needed for Nix to register the command as successful
    touch $out
  ''
