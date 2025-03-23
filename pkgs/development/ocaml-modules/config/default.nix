{
  lib,
  buildDunePackage,
  fetchurl,
  ppxlib,
  spices,
}:

buildDunePackage rec {
  pname = "config";
  version = "0.0.3";

  src = fetchurl {
    url = "https://github.com/ocaml-sys/config.ml/releases/download/${version}/config-${version}.tbz";
    hash = "sha256-bcRCfLX2ro8vnQTJiX2aYGJC+eD26vkPynMYg817YFM=";
  };

  propagatedBuildInputs = [
    ppxlib
    spices
  ];

  meta = {
    description = "Ergonomic, lightweight conditional compilation through attributes";
    homepage = "https://github.com/ocaml-sys/config.ml";
    license = lib.licenses.mit;
  };
}
