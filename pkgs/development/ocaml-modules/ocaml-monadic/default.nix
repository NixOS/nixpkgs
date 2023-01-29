{ lib, fetchFromGitHub, buildDunePackage
, ppxlib
}:

buildDunePackage rec {
  pname = "ocaml-monadic";
  version = "0.5.0";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "zepalmer";
    repo = pname;
    rev = version;
    sha256 = "1ynv3yhdqmkhkgnz6c5kv6ryjcc934sdvw9rhh8rjg2dlzlffgbw";
  };

  buildInputs = [ ppxlib ];

  meta = {
    inherit (src.meta) homepage;
    description = "A PPX extension to provide an OCaml-friendly monadic syntax";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
