{ Security, Foundation, callPackage }:

let
  buildGo = callPackage ./generic.nix {
    inherit Security Foundation;
  };

in
buildGo {
  version = "1.9.4";
  sha256 = "15d9lfiy1cjfz6nqnig5884ykqckx58cynd1bva1xna7bwcwwp2r";
  patches = [
    ./remove-tools-1.9.patch
    ./ssl-cert-file-1.9.patch
    ./creds-test-1.9.patch
    ./remove-test-pie-1.9.patch
    ./go-1.9-skip-flaky-19608.patch
    ./go-1.9-skip-flaky-20072.patch
  ];
  # Extra whitespace line is to not change output hash
  extraPrePatch = ''

    sed -i '1 a\exit 0' misc/cgo/errors/test.bash
  '';
}
