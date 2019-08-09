{ runCommand, purescript, nodejs }:

runCommand "purescript-test-minimal-module" {} ''
  ${purescript}/bin/purs compile -o ./output ${./.}/Main.purs

  echo 'require("./output/Main/index.js").main()' > node.js

  ${nodejs}/bin/node node.js | grep "hello world" || echo "did not output hello world"

  touch $out
''
