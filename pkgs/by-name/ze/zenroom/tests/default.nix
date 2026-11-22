{
  runCommand,
  zenroom,
}:
runCommand "basic-tests"
  {
    nativeBuildInputs = [ zenroom ];
  }
  ''
    mkdir -p $out

    TEST_DIR="${./.}"

    for test in "$TEST_DIR"/*.zen; do
      TEST_NAME="$(basename $test .zen)"
      zenroom -z $test > "$out/$TEST_NAME".json
    done
  ''
