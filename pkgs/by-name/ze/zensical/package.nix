{
  lib,
  fetchPypi,
  rustPlatform,
  python3Packages,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "zensical";
  version = "0.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5krDGJdgKmxKsdWNdjhuCrxChTnLsvdDIRG2+K+o8Z4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-ljNoAaqXAVbnF/9RbXdWvJAac8sh0W3v53YtgiNQEng=";
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

  passthru.updateScript = nix-update-script { };

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
    changelog = "https://github.com/zensical/zensical/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aljazerzen ];
    mainProgram = "zensical";
  };
}
