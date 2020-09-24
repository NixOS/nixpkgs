{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "csexp";
  version = "1.3.2";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    sha256 = "0jhwrxfjb0x31xj4g4b89fzw34sq19j0rq2hs2zyh1vz4xxl47zj";
  };

  postPatch = ''
    substituteInPlace src/csexp.ml --replace Result.result Result.t
  '';

  meta = with lib; {
    homepage = "https://github.com/ocaml-dune/csexp";
    description = "Minimal support for Canonical S-expressions";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
