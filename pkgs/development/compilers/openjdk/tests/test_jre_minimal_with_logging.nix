{ runCommand
, callPackage
, jdk
, jre_minimal
}:

let
  hello-logging = callPackage ./hello-logging.nix {
    jdk = jdk;
    jre = jre_minimal.override {
      modules = [
        "java.base"
        "java.logging"
      ];
    };
  };
in
  runCommand "test" {} ''
    ${hello-logging}/bin/hello &>/dev/stdout | grep "Hello, world!"
    touch $out
  ''
