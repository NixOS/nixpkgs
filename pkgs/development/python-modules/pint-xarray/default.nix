{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
  pint,
  xarray,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pint-xarray";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "pint-xarray";
    tag = "v${version}";
    hash = "sha256-bPvLTtaROCYr8yWI6vQK7pYbBYUlsMzy7ALnufAT7Xo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    pint
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pint_xarray"
  ];

  meta = {
    description = "Interface for using pint with xarray, providing convenience accessors";
    homepage = "https://github.com/xarray-contrib/pint-xarray";
    changelog = "https://github.com/xarray-contrib/pint-xarray/blob/${src.tag}/docs/whats-new.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
