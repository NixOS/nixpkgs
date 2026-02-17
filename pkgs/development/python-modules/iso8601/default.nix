{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  poetry-core,
  pytestCheckHook,
  pytz,
}:

buildPythonPackage rec {
  pname = "iso8601";
  version = "2.1.0";
  pyproject = true;

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

  meta = {
    description = "Simple module to parse ISO 8601 dates";
    homepage = "https://pyiso8601.readthedocs.io/";
    changelog = "https://github.com/micktwomey/pyiso8601/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
