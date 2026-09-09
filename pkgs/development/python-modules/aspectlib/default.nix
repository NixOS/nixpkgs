{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  fields,
  process-tests,
  pytestCheckHook,
  tornado,
}:

buildPythonPackage rec {
  pname = "aspectlib";
  version = "2.0.0";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pLRhudoLUxrry5PvzePegIpyxgIm3Y2QLEZ9E/r3zpI=";
  };

  patches = [
    # https://github.com/ionelmc/python-aspectlib/pull/25
    (fetchpatch {
      name = "darwin-compat.patch";
      url = "https://github.com/ionelmc/python-aspectlib/commit/ef2c12304f08723dc8e79d1c59bc32c946d758dc.patch";
      hash = "sha256-gtPFtwDsGIMkHTyuoiLk+SAGgB2Wyx/Si9HIdoIsvI8=";
    })
    (fetchpatch {
      name = "pluggy-compat.patch";
      url = "https://github.com/ionelmc/python-aspectlib/commit/b85abdb0565d1598ce56bd49d49dc709d4e16081.patch";
      hash = "sha256-hW9xF50RjlrKXyABc69dkiV7YUeee95MnF0J/xQDWd4=";
      includes = [ "tests/conftest.py" ];
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ fields ];

  pythonImportsCheck = [
    "aspectlib"
    "aspectlib.contrib"
    "aspectlib.debug"
    "aspectlib.test"
  ];

  nativeCheckInputs = [
    process-tests
    pytestCheckHook
    tornado
  ];

  pytestFlags = [ "-Wignore::DeprecationWarning" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/ionelmc/python-aspectlib/blob/v${version}/CHANGELOG.rst";
    description = "Aspect-oriented programming, monkey-patch and decorators library";
    homepage = "https://github.com/ionelmc/python-aspectlib";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
