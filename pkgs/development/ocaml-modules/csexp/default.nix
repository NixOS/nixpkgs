{ lib, fetchurl, buildDunePackage, result }:

buildDunePackage rec {
  pname = "csexp";
  version = "1.3.2";

  useDune2 = true;

  minimumOCamlVersion = "4.02.3";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    sha256 = "0jhwrxfjb0x31xj4g4b89fzw34sq19j0rq2hs2zyh1vz4xxl47zj";
  };

  propagatedBuildInputs = [ result ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-dune/csexp";
    description = "Minimal support for Canonical S-expressions";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
