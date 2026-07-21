{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  networkx,

  # tests
  pytestCheckHook,
  numpy,
  pandas,
  scipp,
  xarray,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyclebane";
  version = "24.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "cyclebane";
    tag = finalAttrs.version;
    hash = "sha256-vD/Ajym37GdsJ7iMuhao1SgX+Pd7aapc3b2oujwcopk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    networkx
  ];

  pythonImportsCheck = [
    "cyclebane"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
    scipp
    xarray
  ];

  meta = {
    description = "Transform directed acyclic graphs using map-reduce and groupby operations";
    homepage = "https://scipp.github.io/cyclebane/";
    changelog = "https://github.com/scipp/cyclebane/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
