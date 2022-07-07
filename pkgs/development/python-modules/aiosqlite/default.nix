{ lib
, aiounittest
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aiosqlite";
  version = "0.17.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8OaswkvEhkFJJnrIL7Rt+zvkRV+Z/iHfgmCcxua67lE=";
  };

  checkInputs = [
    aiounittest
    pytestCheckHook
    typing-extensions
  ];

  # tests are not pick-up automatically by the hook
  pytestFlagsArray = [ "aiosqlite/tests/*.py" ];

  pythonImportsCheck = [ "aiosqlite" ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
