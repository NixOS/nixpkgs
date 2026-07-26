{
  runCommand,
  callPackage,
  jdk,
  jre_minimal,
}:

let
  hello = callPackage ./hello.nix {
    inherit jdk;
    jre = jre_minimal;
  };
in
runCommand "test" { } ''
  ${hello}/bin/hello | grep "Hello, world!"
  touch $out
''
