{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pyyaml,
  hist,
  scipy,
  hepdata-validator,
  root,
  imagemagick,
  pytestCheckHook,
  pytest-cov,
  withRootSupport ? false,
}:

buildPythonPackage (finalAttrs: {
  pname = "hepdata_lib";
  version = "0.21.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HEPData";
    repo = "hepdata_lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+RoiH0yFfR2dJxstk4JWUHWNk5TQH6fgEl7f78Ej2KI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pyyaml
    hist
    scipy
    hepdata-validator
  ]
  ++ lib.optionals withRootSupport [ root ];

  nativeCheckInputs = [
    (imagemagick.override { ghostscriptSupport = true; })
    pytest-cov
    pytestCheckHook
  ];

  disabledTestMarks = lib.optionals (!withRootSupport) [ "needs_root" ];

  # These execute example Jupyter notebooks via papermill, requiring extra
  # test-only dependencies (papermill, ipykernel) that are not packaged here.
  disabledTestPaths = [ "tests/test_notebooks.py" ];

  pythonImportsCheck = [ "hepdata_lib" ];

  meta = {
    description = "Library for getting your data into HEPData";
    homepage = "https://github.com/HEPData/hepdata_lib";
    changelog = "https://github.com/HEPData/hepdata_lib/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
