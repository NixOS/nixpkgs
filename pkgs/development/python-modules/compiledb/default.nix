{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, bashlex
, click
, shutilwhich
, gcc
, coreutils
}:

buildPythonPackage rec {
  pname = "compiledb";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "nickdiego";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qricdgqzry7j3rmgwyd43av3c2kxpzkh6f9zcqbzrjkn78qbpd4";
  };

  # fix the tests
  patchPhase = ''
    substituteInPlace tests/data/multiple_commands_oneline.txt \
                      --replace /bin/echo ${coreutils}/bin/echo
  '';

  checkInputs = [ pytest gcc coreutils ];
  propagatedBuildInputs = [ click bashlex shutilwhich ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Tool for generating Clang's JSON Compilation Database files";
    license = licenses.gpl3;
    homepage = https://github.com/nickdiego/compiledb;
    maintainers = with maintainers; [ multun ];
  };
}
