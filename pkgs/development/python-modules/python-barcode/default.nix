{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-barcode";
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WhyNotHugo";
    repo = "python-barcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a/w2JxFBm/jqIRnqIB7ZtkdiLnBNjbR0V5SNuau/YxY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    images = [ pillow ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ]
  ++ finalAttrs.passthru.optional-dependencies.images;

  pythonImportsCheck = [ "barcode" ];

  meta = {
    description = "Create standard barcodes with Python";
    mainProgram = "python-barcode";
    homepage = "https://github.com/WhyNotHugo/python-barcode";
    changelog = "https://github.com/WhyNotHugo/python-barcode/blob/${finalAttrs.src.tag}/docs/changelog.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
