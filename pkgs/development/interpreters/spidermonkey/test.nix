{ runCommand, spidermonkey }:

runCommand "spidermonkey-test-run" {
  nativeBuildInputs = [
    spidermonkey
  ];
} ''
  diff -U3 --color=auto <(js <(echo "console.log('Hello, world\!')")) <(echo 'Hello, world!')
  touch $out
''
