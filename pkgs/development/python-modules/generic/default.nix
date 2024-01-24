{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, exceptiongroup
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.1.2";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gaphor";
    repo = "generic";
    rev = version;
    hash = "sha256-w9Vla5S6VYeoI4tAnHbrfu1xKlEpx2wlMD0iD4Ovlgk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    exceptiongroup
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "generic" ];

  meta = with lib; {
    description = "Generic programming (Multiple dispatch) library for Python";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/generic";
    changelog = "https://github.com/gaphor/generic/releases/tag/${version}";
    license = licenses.bsd3;
  };
}
