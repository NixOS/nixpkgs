{
  runCommand,
  purescript,
  nodejs,
}:

runCommand "purescript-test-minimal-module" { } ''
  ${purescript}/bin/purs compile -o ./output ${./.}/Main.purs

  echo 'import {main} from "./output/Main/index.js"; main()' > node.mjs

  ${nodejs}/bin/node node.mjs | grep "hello world" || (echo "did not output hello world"; exit 1)

  touch $out
''
