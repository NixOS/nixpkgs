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
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidMStraub";
    repo = "gramps-gedcom7";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9o/1J6sDSJ/Db3ncaXfb8FSZ87yRYJUWTHxCRML5yh4=";
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

  disabledTests = [
    # Wrong MIME type detected for .1 file extension
    "test_media_with_an_unknown_type_is_given_one_and_reported"
  ];

  # https://github.com/NixOS/nixpkgs/issues/149812
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-hooks-gobject-introspection
  strictDeps = false;

  pythonImportsCheck = [ "gramps_gedcom7" ];

  meta = {
    description = "GEDCOM 7 support for Gramps";
    homepage = "https://github.com/DavidMStraub/gramps-gedcom7";
    changelog = "https://github.com/DavidMStraub/gramps-gedcom7/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
