{
  lib,
  bottleneck,
  buildPythonPackage,
  fetchPypi,
  jellyfish,
  joblib,
  networkx,
  numexpr,
  numpy,
  pandas,
  pyarrow,
  pytest,
  scikit-learn,
  scipy,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "recordlinkage";
  version = "0.16";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-7NoMEN/xOLFwaBXeMysShfZwrn6MzpJZYhNQHVieaqQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  pythonRelaxDeps = [
    "pandas"
  ];

  dependencies = [
    pyarrow
    jellyfish
    numpy
    pandas
    scipy
    scikit-learn
    joblib
    networkx
    bottleneck
    numexpr
  ];

  # pytestCheckHook does not work
  # Reusing their CI setup which involves 'rm -rf recordlinkage' in preCheck phase do not work too.
  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "recordlinkage" ];

  meta = {
    description = "Library to link records in or between data sources";
    homepage = "https://recordlinkage.readthedocs.io/";
    changelog = "https://github.com/J535D165/recordlinkage/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
