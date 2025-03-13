{
  buildPythonPackage,
  # fetchFromGitHub,
  fetchPypi,
  fetchpatch,
  lib,

  # Build dependencies
  setuptools,

  # Runtime dependencies
  docutils,
  jinja2,
  sphinx,

  # Test dependencies
  ipython,
  matplotlib,
  numpy,
  pillow,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docrepr";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OtYuzaoLerkNzZwpq8mMrn1h0JM58YOW1MpbirQci5A=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/spyder-ide/docrepr/compare/3fcb6430d9f5da8f547a30d08a36244ab31bc65c..a1afbd6c260530a07e92fdc19e72792c9d1dc38c.patch";
      hash = "sha256-jwh48txPUxyx3AmaCyd7H3DP578ETYPt6zBpxtWcosg=";
    })
  ];

  build-system = [ setuptools ];
  dependencies = [
    docutils
    jinja2
    sphinx
  ];

  nativeCheckInputs = [
    ipython
    matplotlib
    numpy
    pillow
    pytest-asyncio
    pytestCheckHook
  ];
  pythonImportsCheck = [ "docrepr.sphinxify" ];

  meta = {
    changelog = "https://github.com/spyder-ide/docrepr/releases/tag/${version}";
    homepage = "https://github.com/spyder-ide/docrepr";
    description = "Renders Python docstrings to rich HTML";
    license = lib.licenses.bsd3;
  };
}
