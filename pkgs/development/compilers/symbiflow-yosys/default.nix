{ stdenv
, abc-verifier
, fetchFromGitHub
, yosys
, plugins ? []
}:

let
  localAbc-verifier = abc-verifier.overrideAttrs (_: rec {
    pname = "abc-verifier";
    version = "2020.06.22";

    src = fetchFromGitHub {
      owner  = "YosysHQ";
      repo   = "abc";
      rev    = "341db25668f3054c87aa3372c794e180f629af5d";
      sha256 = "14cgv34vz5ljkcms6nrv19vqws2hs8bgjgffk5q03cbxnm2jxv5s";
    };

    passthru.rev = src.rev;
  });
in

(yosys.overrideAttrs (oldAttrs: rec {
  pname   = "symbiflow-yosys";
  version = "0.9+2406";

  src = fetchFromGitHub {
    owner  = "SymbiFlow";
    repo   = "yosys";
    rev    = "d8b2d1a2b1a93057678cf49bb8f0329f191faba1";
    sha256 = "1w8jnqzabvzixjllhb6ak2n2gmjvsn6qd996i7z70bsq5rgdkq9g";
  };
})).override {
  abc-verifier = localAbc-verifier;
  plugins = plugins;
}
