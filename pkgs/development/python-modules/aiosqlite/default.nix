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
  version = "0.16.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a0fjmlvadyzsml10g5p1qif7192k0swy5zwjp8v48y5zc3yy56h";
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
