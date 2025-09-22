{
  lib,
  buildPythonPackage,
  fetchPypi,
  jaraco-collections,
  jaraco-itertools,
  jaraco-logging,
  jaraco-stream,
  jaraco-text,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools-scm,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "irc";
  version = "20.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jdv9GfcSBM7Ount8cnJLFbP6h7q16B5Fp1vvc2oaPHY=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    jaraco-collections
    jaraco-itertools
    jaraco-logging
    jaraco-stream
    jaraco-text
    pytz
  ]
  ++ lib.optionals (pythonOlder "3.12") [ importlib-resources ];

  nativeCheckInputs = [ pytestCheckHook ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "irc" ];

  meta = with lib; {
    description = "IRC (Internet Relay Chat) protocol library for Python";
    homepage = "https://github.com/jaraco/irc";
    changelog = "https://github.com/jaraco/irc/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
