{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  click,
  gedcom7,
  gobject-introspection,
  gramps,
  gtk3,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gramps-gedcom7";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "gramps-gedcom7";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yRHDF327gR8R7QcVk+7db+fk0IGo9ZiD3qIodlj7lT0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    gedcom7
    gramps
  ];

  nativeCheckInputs = [
    gobject-introspection
    gtk3
    pytestCheckHook
  ];

  # https://github.com/NixOS/nixpkgs/issues/149812
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-hooks-gobject-introspection
  strictDeps = false;

  pythonImportsCheck = [ "gramps_gedcom7" ];

  meta = {
    description = "GEDCOM 7 support for Gramps";
    homepage = "https://github.com/DavidMStraub/gramps-gedcom7";
    changelog = "https://github.com/DavidMStraub/gramps-gedcom7/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
