{ stdenv, fetchFromGitHub, coq }:

let params =
  {
    "8.5"  = { version = "0.9.4";  sha256 = "1y66pamgsdxlq2w1338lj626ln70cwj7k53hxcp933g8fdsa4hp0"; };
    "8.6"  = { version = "0.9.5";  sha256 = "1b4cvz3llxin130g13calw5n1zmvi6wdd5yb8a41q7yyn2hd3msg"; };
    "8.7"  = { version = "0.9.7";  sha256 = "00v4bm4glv1hy08c8xsm467az6d1ashrznn8p2bmbmmp52lfg7ag"; };
    "8.8"  = { version = "0.11.1"; sha256 = "0dmf1p9j8lm0hwaq0af18jxdwg869xi2jm8447zng7krrq3kvkg5"; };
    "8.9"  = { version = "0.11.1"; sha256 = "0dmf1p9j8lm0hwaq0af18jxdwg869xi2jm8447zng7krrq3kvkg5"; };
    "8.10" = { version = "0.11.1"; sha256 = "0dmf1p9j8lm0hwaq0af18jxdwg869xi2jm8447zng7krrq3kvkg5"; };
    "8.11" = { version = "0.11.1"; sha256 = "0dmf1p9j8lm0hwaq0af18jxdwg869xi2jm8447zng7krrq3kvkg5"; };
  };
  param = params.${coq.coq-version};
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

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/coq-ext-lib/coq-ext-lib;
    description = "A collection of theories and plugins that may be useful in other Coq developments";
    maintainers = with maintainers; [ jwiegley ptival ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };
}
