{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-batteries";
  # nixpkgs-update: no auto update
  version = "4.36.0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "batteries";
    rev = "b4b25a3886a16daacaf6615c2eea7170a6e8f458";
    hash = "sha256-Czw3jHwhL81zQl4r6Dd3o6no2BzDKSHahzEr7TjMMYo=";
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
