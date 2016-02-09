{ buildRubyGem, makeWrapper, ruby, coreutils, bundler }:

buildRubyGem rec {
  inherit ruby;
  buildInputs = [bundler];
  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "2.0.4";
  sha256 = "0i7fdxi6w29yxnblpckczazb79m5x03hja8sfnabndg4yjc868qs";
  dontPatchShebangs = true;
}
