# Builds hello-world Factor application using buildFactorApplication & verifies
# source-to-binary that the resulting app prints "Hello, $NAME" depending on
# `--name` flag.
{
  lib,
  runCommandLocal,
  buildFactorApplication,
  buildFactorVocab,
}:

let
  fs = lib.fileset;

  factorFilter =
    file:
    lib.lists.any file.hasExt [
      "factor"
      "txt"
    ];

  version = "0-test";

  vocab = buildFactorVocab {
    inherit version;
    pname = "hello";
    src = fs.toSource {
      root = ./extra;
      fileset = fs.difference (fs.fileFilter factorFilter ./extra/hello) ./extra/hello/cli;
    };
    vocabName = "hello";
  };

  app = buildFactorApplication {
    inherit version;
    pname = "hello-cli";
    src = fs.toSource {
      root = ./extra;
      fileset = fs.fileFilter factorFilter ./extra/hello/cli;
    };
    vocabName = "hello.cli";
    binName = "hello";
    extraVocabs = [ vocab ];
  };
in
runCommandLocal "assert-factor-hello-world"
  {
    env.expected = "Hello, Nixpkgs";
  }
  ''
    output="$(${lib.getExe app} --name "Nixpkgs")"
    if [ "$output" != "$expected" ]; then
      echo "FAIL: expected “$expected”; got “$output”" >&2
      exit 1
    fi
    touch "$out"
  ''
