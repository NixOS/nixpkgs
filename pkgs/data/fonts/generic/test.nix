{ runCommand, pname, fontforge, _3270font }:

runCommand "${pname}-test" { meta.timeout = 3; }
  ''
  files=$(find ${_3270font} \( -name '*.otf' \
    -o -name '*.ttf' \
    -o -name '*.woff' \) \
    -print)

  if [ -z "$files" ]; then
      echo "No fonts found"
      exit 1
  fi

  mkdir $out
  text="The quick brown fox jumps over the lazy dog."
  for file in $files; do
    ${fontforge}/bin/fontimage --o $out/$(basename $file).png --fontname --text "$text" $file &>/dev/null
  done
  ''
