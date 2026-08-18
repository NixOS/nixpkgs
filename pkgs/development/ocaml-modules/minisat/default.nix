{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
}:

buildDunePackage (finalAttrs: {
  pname = "minisat";
  version = "0.6";

  minimalOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-minisat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dH0Ndlyo/DTZ6Ao1S478aBuxoZFSkRBi5HblkTWCPas=";
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";
  };

  meta = {
    homepage = "https://c-cube.github.io/ocaml-minisat/";
    description = "Simple bindings to Minisat-C";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
})
