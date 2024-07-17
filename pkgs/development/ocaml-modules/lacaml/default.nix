{
  lib,
  stdenv,
  fetchurl,
  darwin,
  buildDunePackage,
  dune-configurator,
  lapack,
  blas,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

buildDunePackage rec {
  pname = "lacaml";
  version = "11.0.10";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mmottl/lacaml/releases/download/${version}/lacaml-${version}.tbz";
    sha256 = "sha256-Vg6Hl31u1bvh0hfWU9eqoI8pGZt4YhpGRf3ul3h+SJk=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    lapack
    blas
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Accelerate ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/lacaml";
    description = "OCaml bindings for BLAS and LAPACK";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.vbgl ];
  };
}
