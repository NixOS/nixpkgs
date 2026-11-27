# The fixed-point check: the .hc files of each stage, module by module, against
# the stage before.  Only stage 5 against stage 4 must be identical in all 220
# modules.  Stage 3 differs from stage 2 because stage 1's shims give other
# FastString uniques, and stage 4 differs from stage 3 in at most two modules
# (an SRT pair in CoreUtils and an uninitialised word in Pretty).
{
  runCommand,
  stage2,
  stage3,
  stage4,
  stage5,
}:

runCommand "ghc-6.2.2-fixpoint" { } ''
  s2=${stage2.hc}/stage2 s3=${stage3.hc}/stage3
  s4=${stage4.hc}/stage4 s5=${stage5}/stage5
  hcs=$(cd "$s2" && find . -name '*.hc' | sort)
  test $(echo "$hcs" | wc -l) = 220
  # compare NEWER OLDER LABEL prints the files that differ and a summary, and
  # sets $diff to their number
  compare() {
    same=0; diff=0
    for f in $hcs; do
      if cmp -s "$1/$f" "$2/$f"; then same=$((same+1)); else diff=$((diff+1)); echo "differs: ''${f#./}"; fi
    done
    echo "$3 .hc: $same identical, $diff differ"
  }
  {
    compare "$s3" "$s2" "stage 3 vs stage 2"
    compare "$s4" "$s3" "stage 4 vs stage 3"
    compare "$s5" "$s4" "stage 5 vs stage 4"; fixdiff="$diff"
    if cmp -s ${stage3}/bin/ghc ${stage4}/bin/ghc; then
      echo "stage 3 and stage 4 bin/ghc are byte-identical"
    else
      echo "stage 3 and stage 4 bin/ghc differ: $(cmp -l ${stage3}/bin/ghc ${stage4}/bin/ghc | wc -l) bytes"
    fi
  } > report.txt
  cat report.txt
  [ "$fixdiff" = 0 ] || { echo "no fixed point: stage 5 and stage 4 differ"; exit 1; }
  mkdir "$out"
  cp report.txt "$out/"
''
