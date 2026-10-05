{
  lib,
  runCommand,
  swift,
}:

runCommand "swift-driver-test-swift-not-on-path" { } ''
  PATH= ${lib.getExe swift} help --help | grep "USAGE: swift-help"
  touch "$out"
''
