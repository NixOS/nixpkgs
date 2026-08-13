{
  lib,
  runCommand,
  writeShellScriptBin,
  system-sendmail,
}:

let
  sendmail = lib.getExe system-sendmail;

  fakeSendmail = writeShellScriptBin "sendmail" ''
    echo "fake sendmail called with: $*"
  '';
in
{
  forwards-args =
    runCommand "system-sendmail-test-forwards-args" { nativeBuildInputs = [ fakeSendmail ]; }
      ''
        actual="$('${sendmail}' -t -oi)"
        expected="fake sendmail called with: -t -oi"

        if [ "$actual" != "$expected" ]; then
          echo "Expected: $expected"
          echo "Actual:   $actual"
          exit 1
        fi

        touch "$out"
      '';

  skips-self = runCommand "system-sendmail-test-skips-self" { } ''
    set +e
    output="$(PATH="${system-sendmail}/bin" '${sendmail}' -t 2>&1)"
    status="$?"
    set -e

    if [ "$status" -eq 0 ]; then
      echo "Expected system-sendmail to fail when no real sendmail is available"
      echo "Output: $output"
      exit 1
    fi

    if [ "$output" != "Unable to find system sendmail." ]; then
      echo "Unexpected output: $output"
      exit 1
    fi

    touch "$out"
  '';
}
