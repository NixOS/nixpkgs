{ stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pytest
}:

buildPythonPackage rec {
  pname = "pytoml";
  version = "0.1.20";

  src = fetchFromGitHub {
    owner = "avakar";
    repo = "pytoml";
    rev = "v${version}";
    fetchSubmodules = true; # ensure test submodule is available
    sha256 = "02hjq44zhh6z0fsbm3hvz34sav6fic90sjrw8g1pkdvskzzl46mz";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    ${python.interpreter} test/test.py
    pytest test
  '';


  meta = with stdenv.lib; {
    description = "A TOML parser/writer for Python";
    homepage    = https://github.com/avakar/pytoml;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
