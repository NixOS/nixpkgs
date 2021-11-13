{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "3.0.2";
  format = "pyproject";
  disabled = pythonOlder "3.6.1";

  src = fetchFromGitHub {
    owner = "jodal";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cy4pr05xlsny9g573q7njsv7jaaysi1qzafm6f82y57jqnmziks";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  meta = with lib; {
    homepage = "https://www.pykka.org/";
    description = "A Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/blob/v${version}/docs/changes.rst";
    maintainers = with maintainers; [ marsam ];
    license = licenses.asl20;
  };
}
