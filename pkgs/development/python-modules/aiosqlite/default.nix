{ lib
, buildPythonPackage
, fetchFromGitHub
, typing-extensions
, aiounittest
, coverage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosqlite";
  version = "0.16.0";
  format = "flit";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = pname;
    rev = "v${version}";
    sha256 = "qdWD3yyN9E+SHecZrpD/MDGWBpsx95/14CY1ElBTbX4=";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkInputs = [
    aiounittest
    coverage
  ];

  checkPhase = ''
    python -m coverage run -m aiosqlite.tests
  '';

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
