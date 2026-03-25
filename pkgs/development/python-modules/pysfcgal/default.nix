{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,

  cffi,
  icontract,
  setuptools,
  sfcgal,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysfcgal";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "sfcgal";
    repo = "pysfcgal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/G6yC7u2CYM7D9xO2IOB8+AjWc4ErzTIdvHmwGRxXBc=";
  };

  buildInputs = [
    sfcgal
  ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    cffi
  ];

  pythonImportsCheck = [
    "pysfcgal"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    icontract
  ];

  # remove src module, so tests use the installed module instead
  preCheck = ''
    rm -rf pysfcgal
  '';

  disabledTests = [
    # this test is failing due to mismatched output
    "test_wrap_geom_segfault"
  ];

  meta = {
    description = "Python wrapper for SFCGAL";
    homepage = "https://gitlab.com/sfcgal/pysfcgal";
    changelog = "https://gitlab.com/sfcgal/pysfcgal/-/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    teams = with lib.teams; [
      geospatial
      ngi
    ];
  };
})
