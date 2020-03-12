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
  version = "0.11.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jreese";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pmkp4iy738yv2sl08kvhd0ma6wjqbmfnwid72gvg4zqsr1hnn0z";
  };

  buildInputs = [
    setuptools
  ];

  checkInputs = [
    aiounittest
  ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = https://github.com/jreese/aiosqlite;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
