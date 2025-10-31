{
  cudaNamePrefix,
  cudnn-frontend,
  jq,
  lib,
  writeShellApplication,
}:
let
  inherit (lib.meta) getExe';
in
writeShellApplication {
  derivationArgs = {
    __structuredAttrs = true;
    strictDeps = true;
  };
  name = "${cudaNamePrefix}-tests-cudnn-frontend-tests";
  runtimeInputs = [
    cudnn-frontend.tests
    jq
  ];
  text = ''
    args=( "${getExe' cudnn-frontend.tests "tests"}" )

    if (( $# != 0 ))
    then
      args+=( "$@" )
      "''${args[@]}"
    else
      args+=(
        --success
        --rng-seed=0
        --reporter=json
      )
      echo "Running with default arguments: ''${args[*]}" >&2
      "''${args[@]}" | jq
    fi
  '';
}
