{ lib
, buildPythonPackage
, fetchFromGitHub
, databases
, typesystem
, aiosqlite
, pytestCheckHook
, pytestcov
, typing-extensions
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
    pytestCheckHook
    pytestcov
    typing-extensions
  ];

  pythonImportsCheck = [ "orm" ];

  meta = with lib; {
    description = "An async ORM";
    homepage = "https://github.com/encode/orm";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
