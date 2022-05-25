# Simple tests for multiple module files functionality.
# In the future, would like to test precedence, more than two files, unexpected inputs/fuzzing.
{ runCommand, gdk-pixbuf, librsvg}:
runCommand "pixbuf-mmf-test" {} ''
  mkdir -p $out
  set +e

  function test {
    modulepath=$1
    testfile=$2
    GDK_PIXBUF_MODULE_FILE=$modulepath ${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer $testfile $out/$(basename $testfile) > /dev/null
  }

  test ${gdk-pixbuf}/${gdk-pixbuf.cacheFile} ${./sample.svg}
  if ! (($?)); then
    >&2 echo "This shouldn't happen? SVG parsing succeeded even though librsvg wasn't supplied."
    exit 1
  fi

  test ${gdk-pixbuf}/${gdk-pixbuf.cacheFile}:${librsvg}/${gdk-pixbuf.cacheFile} ${./sample.svg}
  if (($?)); then
    >&2 echo "Test failed."
    exit 1
  fi

  test ${librsvg}/${gdk-pixbuf.cacheFile}:${gdk-pixbuf}/${gdk-pixbuf.cacheFile} ${./sample.svg}
  if (($?)); then
    >&2 echo "Test failed."
    exit 1
  fi

  set -e
  exit 0
''
