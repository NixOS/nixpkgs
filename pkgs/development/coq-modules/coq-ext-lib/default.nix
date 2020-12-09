{ stdenv, fetchFromGitHub, coq, ...}@args:

let
  hashes = {
    "0.9.4" = "1y66pamgsdxlq2w1338lj626ln70cwj7k53hxcp933g8fdsa4hp0";
    "0.9.5" = "1b4cvz3llxin130g13calw5n1zmvi6wdd5yb8a41q7yyn2hd3msg";
    "0.9.7" = "00v4bm4glv1hy08c8xsm467az6d1ashrznn8p2bmbmmp52lfg7ag";
    "0.10.0" = "1kxi5bmjwi5zqlqgkyzhhxwgcih7wf60cyw9398k2qjkmi186r4a";
    "0.10.1" = "0r1vspad8fb8bry3zliiz4hfj4w1iib1l2gm115a94m6zbiksd95";
    "0.10.2" = "1b150rc5bmz9l518r4m3vwcrcnnkkn9q5lrwygkh0a7mckgg2k9f";
    "0.10.3" = "0795gs2dlr663z826mp63c8h2zfadn541dr8q0fvnvi2z7kfyslb";
    "0.11.1" = "0dmf1p9j8lm0hwaq0af18jxdwg869xi2jm8447zng7krrq3kvkg5";
    "0.11.2" = "0iyka81g26x5n99xic7kqn8vxqjw8rz7vw9rs27iw04lf137vzv6";
    "0.11.3" = "1w99nzpk72lffxis97k235axss5lmzhy5z3lga2i0si95mbpil42";
  };

  default-versions = {
    "8.5" = "0.9.4";
    "8.6" = "0.9.5";
    "8.7" = "0.9.7";
    "8.8" = "0.11.3";
    "8.9" = "0.11.3";
    "8.10" = "0.11.3";
    "8.11" = "0.11.3";
    "8.12" = "0.11.3";
  };

  param = rec {
    version = args.version or default-versions.${coq.coq-version};
    sha256 = hashes.${version};
  };

in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-coq-ext-lib-${version}";
  inherit (param) version;

  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "coq-ext-lib";
    rev = "v${version}";
    inherit (param) sha256;
  };

  buildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/coq-ext-lib/coq-ext-lib";
    description = "A collection of theories and plugins that may be useful in other Coq developments";
    maintainers = with maintainers; [ jwiegley ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v default-versions;
  };
}
