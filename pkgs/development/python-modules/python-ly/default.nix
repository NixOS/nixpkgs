{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  lxml,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-ly";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = "python-ly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CMMssU+qoHbhdny0sgpoYQas4ySPVHnu7GPnSthuMuE=";
  };

  pythonImportsCheck = [ "ly" ];

  build-system = [ hatchling ];

  # Tests seem to be broken ATM: https://github.com/wbsoft/python-ly/issues/70
  doCheck = false;
  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/frescobaldi/python-ly/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Tool and library for manipulating LilyPond files";
    longDescription = ''
      This package provides a Python library ly containing various
      Python modules to parse, manipulate or create documents in
      LilyPond format.  A command line program ly is also provided
      that can be used to do various manipulations with LilyPond
      files.

      The LilyPond format is a plain text input format that is used by
      the GNU music typesetter [LilyPond](https://lilypond.org).
    '';
    homepage = "https://pypi.org/project/python-ly";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ly";
  };
})
