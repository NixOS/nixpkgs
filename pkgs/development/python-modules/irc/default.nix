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
  version = "20.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fSUX9VZta/Oqhdf5jHdYth8NY+6RW/2fb1ZxOXNmRPk=";
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
    maintainers = with maintainers; [ ];
  };
}
