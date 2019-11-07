{ stdenv, fetchFromGitHub, coq, version ? null }:

let
  coq-ext-lib-versions = {
    "0_9_4" = { version = "0.9.4"; sha256 = "1y66pamgsdxlq2w1338lj626ln70cwj7k53hxcp933g8fdsa4hp0"; };
    "0_9_5" = { version = "0.9.5"; sha256 = "1b4cvz3llxin130g13calw5n1zmvi6wdd5yb8a41q7yyn2hd3msg"; };
    "0_9_7" = { version = "0.9.7"; sha256 = "00v4bm4glv1hy08c8xsm467az6d1ashrznn8p2bmbmmp52lfg7ag"; };
    "0_10_0" = { version = "0.10.0"; sha256 = "1kxi5bmjwi5zqlqgkyzhhxwgcih7wf60cyw9398k2qjkmi186r4a"; };
    "0_10_1" = { version = "0.10.1"; sha256 = "0r1vspad8fb8bry3zliiz4hfj4w1iib1l2gm115a94m6zbiksd95"; };
    "0_10_2" = { version = "0.10.2"; sha256 = "1b150rc5bmz9l518r4m3vwcrcnnkkn9q5lrwygkh0a7mckgg2k9f"; };
    "0_10_3" = { version = "0.10.3"; sha256 = "0795gs2dlr663z826mp63c8h2zfadn541dr8q0fvnvi2z7kfyslb"; };
  };
  default-versions =
  {
    "8.5" = coq-ext-lib-versions."0_9_4";
    "8.6" = coq-ext-lib-versions."0_9_5";
    "8.7" = coq-ext-lib-versions."0_9_7";
    "8.8" = coq-ext-lib-versions."0_10_3";
    "8.9" = coq-ext-lib-versions."0_10_3";
  };
  param =
    if version != null
    then coq-ext-lib-versions.${version}
    else default-versions.${coq.coq-version};
in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-coq-ext-lib-${version}";
  inherit (param) version;

  src = fetchFromGitHub {
    owner = "coq-ext-lib";
    repo = "coq-ext-lib";
    rev = "v${param.version}";
    inherit (param) sha256;
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://github.com/coq-ext-lib/coq-ext-lib;
    description = "A collection of theories and plugins that may be useful in other Coq developments";
    maintainers = with maintainers; [ jwiegley ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v default-versions;
  };
}
