{
  lib,
  fetchurl,
  buildDunePackage,
  dune-configurator,
  lapack,
  blas,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

buildDunePackage rec {
  pname = "lacaml";
  version = "11.1.1";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mmottl/lacaml/releases/download/${version}/lacaml-${version}.tbz";
    sha256 = "sha256-NEs7A/lfA+8AE6k19EPW02e1pseDE7HobGSB/ZwLcoc=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    lapack
    blas
  ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/lacaml";
    description = "OCaml bindings for BLAS and LAPACK";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.vbgl ];
  };
}
