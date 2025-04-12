{ runCommand, postcss-cli }:

let
  inherit (postcss-cli) packageName version;
in

runCommand "${packageName}-tests" { meta.timeout = 60; } ''
  # get version of installed program and compare with package version
  claimed_version="$(${postcss-cli}/bin/postcss --version)"
  if [[ "$claimed_version" != "${version}" ]]; then
    echo "Error: program version does not match package version ($claimed_version != ${version})"
    exit 1
  fi

  # run basic help command
  ${postcss-cli}/bin/postcss --help > /dev/null

  # basic autoprefixer test
  config_dir="$(mktemp -d)"
  clean_up() {
    rm -rf "$config_dir"
  }
  trap clean_up EXIT
  echo "
    module.exports = {
      plugins: {
        'autoprefixer': { overrideBrowserslist: 'chrome 40' },
      },
    }
  " > "$config_dir/postcss.config.js"
  input='a{ user-select: none; }'
  expected_output='a{ -webkit-user-select: none; user-select: none; }'
  actual_output="$(echo $input | ${postcss-cli}/bin/postcss --no-map --config $config_dir)"
  if [[ "$actual_output" != "$expected_output" ]]; then
    echo "Error: autoprefixer did not output the correct CSS:"
    echo "$actual_output"
    echo "!="
    echo "$expected_output"
    exit 1
  fi

  # needed for Nix to register the command as successful
  touch $out
''
