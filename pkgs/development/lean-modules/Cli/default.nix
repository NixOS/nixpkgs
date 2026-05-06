{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage (finalAttrs: {
  pname = "lean4-cli";
  # nixpkgs-update: no auto update
  version = "4.29.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCUl4sXVmwtYPuQecEUFH6mwFzPaQY7au4624EOiWjk=";
  };

  leanPackageName = "Cli";

  # Pre-build static library for downstream executables.
  # TODO: upstream this to lean4-cli
  postPatch = ''
    substituteInPlace lakefile.toml \
      --replace-fail '[[lean_lib]]
    name = "Cli"' '[[lean_lib]]
    name = "Cli"
    defaultFacets = ["static"]'
  '';

  meta = {
    description = "Command-line argument parser for Lean 4";
    homepage = "https://github.com/leanprover/lean4-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
})
