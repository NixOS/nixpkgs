{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  poetry-core,
  pytestCheckHook,
  pytz,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "2.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ax04Ke6JIcQwGZjJCfeCn6ntPL2sDTsWry10Ou0bqN8=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytz
  ];

  enabledTestPaths = [ "iso8601" ];

  pythonImportsCheck = [ "iso8601" ];

  meta = with lib; {
    description = "Simple module to parse ISO 8601 dates";
    homepage = "https://pyiso8601.readthedocs.io/";
    changelog = "https://github.com/micktwomey/pyiso8601/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
