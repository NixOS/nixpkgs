{ runCommand
, languageMachines
}:

runCommand "frog-test" {} ''
  ${languageMachines.frog}/bin/frog >$out <<EOF
  Dit is een test
  
  EOF
  echo "Frog output:"
  cat $out

  expected () {
    echo "Test expectation failed: $@"
    exit 1
  }

  lines="$(wc -l $out | awk '{print $1}')"
  test 5 = $lines || expected "Five lines of output"
  grep "is" $out | grep "zijn" >/dev/null || expected "Stemming works"
  grep "een" $out | grep "onbep" >/dev/null || expected "Tagging works"

  deps="$(echo $(awk 'BEGIN { FS = "\t*" } ; {print $1 " -> " $9 "; "}' <$out))"
  test "1 -> 2; 2 -> 0; 3 -> 4; 4 -> 2; -> ;" = "$deps" || expected "Dependency parsing works"
''
