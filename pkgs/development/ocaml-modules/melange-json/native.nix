{
  buildDunePackage,
  melange-json,
  ppxlib,
  yojson,
}:

buildDunePackage {
  pname = "melange-json-native";
  inherit (melange-json) version src;
  minimalOCamlVersion = "4.12";
  propagatedBuildInputs = [
    ppxlib
    yojson
  ];
  doCheck = false; # Fails due to missing "melange-jest", which in turn fails in command "npx jest"
  meta = melange-json.meta // {
    description = "Compositional JSON encode/decode PPX for OCaml";
  };
}
