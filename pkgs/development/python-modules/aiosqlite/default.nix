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
  version = "0.16.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e915463164efa65b60fd1901aceca829b6090082f03082618afca6fb9c8fdf7";
  };

  checkInputs = [
    aiounittest
    pytestCheckHook
    typing-extensions
  ];

  # tests are not pick-up automatically by the hook
  pytestFlagsArray = [ "aiosqlite/tests/*.py" ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
