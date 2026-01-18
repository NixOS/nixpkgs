{
  lib,
  fetchPypi,
  rustPlatform,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "zensical";
  version = "0.0.16";
  pyproject = true;

  # We fetch from PyPi, because GitHub repo does not contain all sources.
  # The publish process also copies in assets from zensical/ui.
  # We could combine sources, but then nix-update won't work.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C3WduiRUGXvb8bEz3E6mToIC5nVwNqbrqtfkXsCgnbg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ksFmYf9Yu+xlQw3tSa1mwdWlOhyK4hqtEZq4dULL4Fs=";
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
    changelog = "https://github.com/zensical/zensical/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aljazerzen ];
    mainProgram = "zensical";
  };
}
