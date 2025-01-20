{
  runCommandLocal,
  racket,

  version ? racket.version,
  variant ? "cs",
}:

runCommandLocal "racket-test-get-version-and-variant"
  {
    nativeBuildInputs = [ racket ];
  }
  ''
    expectation="${version}"

    output="$(racket -e '(display (version))')"

    if test "$output" != "$expectation"; then
        echo "output mismatch: expected ''${expectation}, but got ''${output}"
        exit 1
    fi

    expectation="${variant}"

    output="$(racket -e '(require launcher/launcher) (display (current-launcher-variant))')"

    if test "$output" != "$expectation"; then
        echo "output mismatch: expected ''${expectation}, but got ''${output}"
        exit 1
    fi

    touch $out
  ''
