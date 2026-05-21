# Builds a basic hello-world Factor application using buildFactorApplication &
# verifies source-to-binary that the resulting app prints "Hello, $NAME"
# depending on `--name` flag.
{
  lib,
  runCommandLocal,
  buildFactorApplication,
}:

let
  app = buildFactorApplication {
    pname = "hello";
    version = "test";
    src = ./extra;
    vocabName = "hello";

    doInstallCheck = true;
    installCheckPhase = "";
  };
in
runCommandLocal "assert-factor-hello-world"
  {
    env.expected = "Hello, Nixpkgs";
  }
  ''
    echo "App path: ${app}" >&2
    output="$(${lib.getExe app} --name "Nixpkgs")"
    if [ "$output" != "$expected" ]; then
      echo "FAIL: expected “$expected”; got “$output”" >&2
      exit 1
    fi
    touch "$out"
  ''
