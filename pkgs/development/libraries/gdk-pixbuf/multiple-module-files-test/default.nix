# Simple tests for multiple module files functionality.
# gdk-pixbuf-thumbnailer is used as a simple, command-line consumer of loaders.
# In the future, would like to test unexpected inputs/fuzzing.
{ runCommand, gdk-pixbuf, librsvg, callPackage, imagemagick}:
let
  thumbnailer = "${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer";

  pixbufloader = gdk-pixbuf + "/" + gdk-pixbuf.cacheFile;
  svgloader = librsvg + "/" + gdk-pixbuf.cacheFile;
  redloader = (callPackage ./test-loader.nix {outputColor="#FF0000";}) + "/" + gdk-pixbuf.cacheFile;
  blueloader = (callPackage ./test-loader.nix {outputColor="#0000FF";}) + "/" + gdk-pixbuf.cacheFile;

  svgsample = ./sample.svg;
  gifsample = ./sample.gif;
in runCommand "pixbuf-mmf-test" {} ''
  mkdir -p $out
  set +e

  function svgtest {
    modulepath=$1
    GDK_PIXBUF_MODULE_FILE=$modulepath "${thumbnailer}" "${svgsample}" "$out/thumbnail.png"
  }

  function colortest {
    modulepath=$1
    checkcolor=$2
    GDK_PIXBUF_MODULE_FILE=$modulepath "${thumbnailer}" "${gifsample}" "$out/thumbnail.png"
    "${imagemagick}/bin/convert" "$out/thumbnail.png" -resize 1x1 "$out/summarized.txt"
    grep "$checkcolor" "$out/summarized.txt"
  }

  # sanity check
  if svgtest "${pixbufloader}"; then
    >&2 echo "Test failed. SVG parsing succeeded even though librsvg loader wasn't provided. This shouldn't happen?"
    exit 1
  fi

  # basic check for multiple file loading
  if ! svgtest "${pixbufloader}:${svgloader}"; then
    >&2 echo "Test failed. Second module file couldn't be loaded."
    exit 2
  fi

  # check that priority goes to earlier entries in the list
  if ! colortest "${redloader}:${pixbufloader}:${blueloader}" "#FF0000"; then
    if colortest "${redloader}:${pixbufloader}:${blueloader}" "#0000FF"; then
      >&2 echo "Test failed. Path order priority is incorrect."
      exit 3
    else
      >&2 echo "Test failed. Unknown error with test loader code."
      exit 4
    fi
  fi

  echo "Tests succeeded for gdk-pixbuf multiple module files patch."
  exit 0
''
