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
}:

buildPythonPackage rec {
  pname = "irc";
  version = "20.4.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dXguOB679BBEP3kU/XTKF/vcRBTRTUjaVhSZ6wlY0AI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    jaraco-collections
    jaraco-itertools
    jaraco-logging
    jaraco-stream
    jaraco-text
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "irc" ];

  meta = with lib; {
    description = "IRC (Internet Relay Chat) protocol library for Python";
    homepage = "https://github.com/jaraco/irc";
    changelog = "https://github.com/jaraco/irc/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
