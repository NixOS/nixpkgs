{ Security, Foundation, callPackage }:

let
  buildGo = callPackage ./generic.nix {
    inherit Security Foundation;
  };

in
buildGo {
  version = "1.10";
  sha256 = "1dzs1mz3zxgg1qyi2lrlxdz1lsvazxvmj9cb69pgqnwjlh3jpw0l";
  patches = [
    ./remove-tools-1.9.patch
    ./ssl-cert-file-1.9.patch
    ./remove-test-pie.patch
    ./creds-test.patch
    ./go-1.9-skip-flaky-19608.patch
    ./go-1.9-skip-flaky-20072.patch
  ];
}
