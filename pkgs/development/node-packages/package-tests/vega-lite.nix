{ runCommand, vega-lite }:

let
  inherit (vega-lite) packageName version;
in

runCommand "${packageName}-tests" { meta.timeout = 60; } ''
  # get version of installed program and compare with package version
  claimed_version="$(${vega-lite}/bin/vl2vg --version)"
  if [[ "$claimed_version" != "${version}" ]]; then
    echo "Error: program version does not match package version ($claimed_version != ${version})"
    exit 1
  fi

  # run dummy commands
  ${vega-lite}/bin/vl2vg --help > /dev/null
  ${vega-lite}/bin/vl2svg --help > /dev/null
  ${vega-lite}/bin/vl2png --help > /dev/null
  ${vega-lite}/bin/vl2pdf --help > /dev/null

  # needed for Nix to register the command as successful
  touch $out
''
