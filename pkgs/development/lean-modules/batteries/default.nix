{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-batteries";
  # nixpkgs-update: no auto update
  version = "4.33.0-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "batteries";
    rev = "4488d40d070b9700d4d5a6aa342f0d40c31b2a2d";
    hash = "sha256-71DddBZmdR4wIdeSm9obApnqp0FgDPhqDsC3x/n9bVs=";
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
