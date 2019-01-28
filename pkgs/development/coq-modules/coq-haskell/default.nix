{ stdenv, fetchgit, coq, ssreflect }:

let params =
  {
    "8.5" = {
      version = "20171215";
      rev = "e2cf8b270c2efa3b56fab1ef6acc376c2c3de968";
      sha256 = "09dq1vvshhlhgjccrhqgbhnq2hrys15xryfszqq11rzpgvl2zgdv";
    };

    "8.6" = {
      version = "20171215";
      rev = "e2cf8b270c2efa3b56fab1ef6acc376c2c3de968";
      sha256 = "09dq1vvshhlhgjccrhqgbhnq2hrys15xryfszqq11rzpgvl2zgdv";
    };

    "8.7" = {
      version = "20171215";
      rev = "e2cf8b270c2efa3b56fab1ef6acc376c2c3de968";
      sha256 = "09dq1vvshhlhgjccrhqgbhnq2hrys15xryfszqq11rzpgvl2zgdv";
    };

    "8.8" = {
      version = "20171215";
      rev = "e2cf8b270c2efa3b56fab1ef6acc376c2c3de968";
      sha256 = "09dq1vvshhlhgjccrhqgbhnq2hrys15xryfszqq11rzpgvl2zgdv";
    };
  };
  param = params."${coq.coq-version}" or params."8.8";
in

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-coq-haskell-${param.version}";

  src = fetchgit {
    url = git://github.com/jwiegley/coq-haskell.git;
    inherit (param) rev sha256;
  };

  buildInputs = with coq.ocamlPackages; [ ocaml camlp5 findlib ];
  propagatedBuildInputs = [ coq ssreflect ];

  enableParallelBuilding = false;

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jwiegley/coq-haskell;
    description = "A library for formalizing Haskell types and functions in Coq";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };
}
