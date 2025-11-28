{
  lib,
  fetchurl,
  buildDunePackage,
  dune-configurator,
  lapack,
  blas,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

buildDunePackage (finalAttrs: {
  pname = "lacaml";
  version = "11.1.1";

  src = fetchurl {
    url = "https://github.com/mmottl/lacaml/releases/download/${finalAttrs.version}/lacaml-${finalAttrs.version}.tbz";
    hash = "sha256-NEs7A/lfA+8AE6k19EPW02e1pseDE7HobGSB/ZwLcoc=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    lapack
    blas
  ];

  meta = {
    homepage = "https://mmottl.github.io/lacaml";
    description = "OCaml bindings for BLAS and LAPACK";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
