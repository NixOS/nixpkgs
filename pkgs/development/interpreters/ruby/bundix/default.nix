{ ruby, fetchgit, buildRubyGem, bundler }:

let
  thor = buildRubyGem {
    gemName = "thor";
    version = "0.19.1";
    type = "gem";
    sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
  };

in buildRubyGem {
  gemName = "bundix";
  version = "1.0.4";
  gemPath = [ thor bundler ];
  src = fetchgit {
    url = "https://github.com/cstrahan/bundix.git";
    rev = "6dcf1f71c61584f5c9b919ee9df7b0c554862076";
    sha256 = "1w17bvc9srcgr4ry81ispcj35g9kxihbyknmqp8rnd4h5090b7b2";
  };
}
