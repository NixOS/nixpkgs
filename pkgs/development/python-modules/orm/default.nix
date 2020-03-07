{ lib
, buildPythonPackage
, fetchFromGitHub
, databases
, typesystem
, aiosqlite
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "orm";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "orm";
    rev = version;
    sha256 = "1g70cr0559iyqfzidwh6n2qq6d4dcnrr4sg0jkn1s4qzka828mj7";
  };

  propagatedBuildInputs = [
    databases
    typesystem
  ];

  checkInputs = [
    aiosqlite
    pytest
    pytestcov
  ];

  checkPhase = ''
    PYTHONPATH=$PYTHONPATH:. pytest
  '';

  meta = with lib; {
    description = "An async ORM";
    homepage = https://github.com/encode/orm;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
