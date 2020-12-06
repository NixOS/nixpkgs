{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, aiounittest
, isPy27
, pytest
}:

buildPythonPackage rec {
  pname = "aiosqlite";
  version = "0.12.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jreese";
    repo = pname;
    rev = "v${version}";
    sha256 = "090vdv210zfry0bms5b3lmm06yhiyjb8ga96996cqs611l7c2a2j";
  };

  buildInputs = [
    setuptools
  ];

  checkInputs = [
    aiounittest
  ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
