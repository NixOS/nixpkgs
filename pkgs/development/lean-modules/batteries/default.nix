{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-batteries";
  # nixpkgs-update: no auto update
  version = "4.29.0-unstable-2026-03-27";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "batteries";
    rev = "756e3321fd3b02a85ffda19fef789916223e578c";
    hash = "sha256-sEIDi2i2FaLTgKYWt/kzqPrjMdf+bFURfhw6ZZWBawQ=";
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
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
