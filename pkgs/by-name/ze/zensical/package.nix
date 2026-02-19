{
  lib,
  fetchPypi,
  rustPlatform,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "zensical";
  version = "0.0.23";
  pyproject = true;

  # We fetch from PyPi, because GitHub repo does not contain all sources.
  # The publish process also copies in assets from zensical/ui.
  # We could combine sources, but then nix-update won't work.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XE/DqvB135nYz0G58lZuTViBgNmolJMBTTYH3+UKxLw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-cS8gxMPRpMMHwrjqXjyxBl4dbwll01Y+G4eOBZ3/vdM=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  dependencies = with python3Packages; [
    click
    deepmerge
    markdown
    pygments
    pymdown-extensions
    pyyaml
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Static site generator for documentation";
    longDescription = ''
      Zensical is a modern static site generator designed to simplify
      building and maintaining project documentation.  It's built by
      the creators of Material for MkDocs and shares the same core
      design principles and philosophy – batteries included, easy to
      use, with powerful customization options.
    '';
    homepage = "https://zensical.org";
    changelog = "https://github.com/zensical/zensical/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aljazerzen ];
    mainProgram = "zensical";
  };
})
