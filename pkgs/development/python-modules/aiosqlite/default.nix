{ lib
, aiounittest
, buildPythonPackage
, fetchPypi
, flit-core
, isPy27
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "aiosqlite";
  version = "0.18.0";
  format = "pyproject";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+qhD71+wi6/pqbOFkBLT2db3fONjeJneIGBrf8OaohM=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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
