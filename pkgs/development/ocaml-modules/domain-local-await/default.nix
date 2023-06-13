{ lib
, buildDunePackage
, fetchurl
, mdx
}:

buildDunePackage rec {
  pname = "domain-local-await";
  version = "0.2.0";

  minimalOCamlVersion = "5.0";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "2DCJsI3nGPtbXnU8jRvzR1iNAkNuekVy4Lid1qnHXDo=";
  };

  checkInputs = [
    mdx
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  meta = {
    homepage = "https://github.com/ocaml-multicore/ocaml-${pname}";
    changelog = "https://github.com/ocaml-multicore/ocaml-${pname}/raw/v${version}/CHANGES.md";
    description = "A scheduler independent blocking mechanism";
    license = with lib.licenses; [ bsd0 ];
    maintainers = with lib.maintainers; [ toastal ];
  };
}
