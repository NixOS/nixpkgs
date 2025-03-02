{
  lib,
  buildPythonPackage,
  pythonOlder,
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

  disabled = pythonOlder "3.7";

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

  pytestFlagsArray = [ "-W ignore::DeprecationWarning" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/ionelmc/python-aspectlib/blob/v${version}/CHANGELOG.rst";
    description = "Aspect-oriented programming, monkey-patch and decorators library";
    homepage = "https://github.com/ionelmc/python-aspectlib";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
