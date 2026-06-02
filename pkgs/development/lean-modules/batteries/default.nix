{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-batteries";
  version = "4.30.0";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "batteries";
    tag = "v4.30.0";
    hash = "sha256-OOcKCQEgnn9zkkwjHOovMb/IprNomTDufLOfEXs7hFU=";
  };

  leanPackageName = "batteries";

  # Pre-build static library for downstream executables.
  # TODO: upstream this to batteries
  postPatch = ''
    substituteInPlace lakefile.toml \
      --replace-fail '[[lean_lib]]
    name = "Batteries"' '[[lean_lib]]
    name = "Batteries"
    defaultFacets = ["static"]'
  '';

  meta = {
    description = "The batteries-included extended library for Lean 4";
    homepage = "https://github.com/leanprover-community/batteries";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      nadja-y
      niklashh
    ];
  };
}
