{ xunit-viewer, runCommand, ... }:

runCommand "test-xunit-viewer" {
  nativeBuildInputs = [ xunit-viewer ];
} ''
  mkdir $out
  xunit-viewer -r ${./example.junit.xml} -o $out/index.html
  ( set -x
    grep '<body' $out/index.html
    # Can't easily grep for parts of the original data, because it ends up
    # embedded as base64 encoded data (and slightly modified?).
    # We'd have to really dissect it or render it with a browser.
    # Fortunately, we've already caught the most severe packaging problems
    # with just this.
  )
''
