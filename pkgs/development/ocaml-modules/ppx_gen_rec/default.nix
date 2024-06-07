{ lib, fetchurl, buildDunePackage, ppxlib }:

buildDunePackage rec {
  pname = "ppx_gen_rec";
  version = "2.0.0";

  src = fetchurl {
    url = "https://github.com/flowtype/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "sha256-/mMj5UT22KQGVy1sjgEoOgPzyCYyeDPtWJYNDvQ9nlk=";
  };

  minimalOCamlVersion = "4.07";
  duneVersion = "3";

  buildInputs = [ ppxlib ];

  meta = with lib; {
    homepage = "https://github.com/flowtype/ocaml-ppx_gen_rec";
    description = "A ppx rewriter that transforms a recursive module expression into a struct";
    license = licenses.mit;
    maintainers = with maintainers; [ frontsideair ];
  };
}
