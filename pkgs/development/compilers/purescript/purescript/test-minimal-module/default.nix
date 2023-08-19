{ runCommand, purescript, nodejs }:

runCommand "purescript-test-minimal-module" {} ''
  ${purescript}/bin/purs compile -o ./output ${./.}/Main.purs

  echo 'import {main} from "./output/Main/index.js"; main()' > node.mjs

  ${lib.getExe nodejs} node.mjs | grep "hello world" || (echo "did not output hello world"; exit 1)

  touch $out
''
