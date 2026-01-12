{
  lib,
  buildDunePackage,
  fetchurl,
  fetchpatch,
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

  # Compatibility with ppxlib 0.36
  patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
    url = "https://github.com/ocaml-sys/config.ml/commit/89222d8088cc3c530eb0094d7ff8ec8a67da07d1.patch";
    hash = "sha256-/jNsUXoUrfza5BCpEo7XtEjKwQX3ofEq99v0+UBh7ss=";
  });

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
