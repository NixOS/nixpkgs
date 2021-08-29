{ runCommand
, callPackage
, jdk
, jre_minimal
}:

let
  hello = callPackage tests/hello.nix {
    jdk = jdk;
    jre = jre_minimal;
  };
in
  runCommand "test" {} ''
    ${hello}/bin/hello | grep "Hello, world!"
    touch $out
  ''
