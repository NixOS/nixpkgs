{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem rec {
  inherit ruby;
  name = "${gemName}-${version}";
  gemName = "bundler";
  version = "1.10.6";
  sha256 = "1vlzfq0bkkj4jyq6av0y55mh5nj5n0f3mfbmmifwgkh44g8k6agv";
  dontPatchShebangs = true;
}
