{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, setuptools
, types-setuptools
}:

buildPythonPackage rec {
  pname = "requirements-parser";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "madpah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-e2dfVBMh1uGRMDw7OdPefO4/eRxc3BGwvy/D7u5ipkk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    setuptools
    types-setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "requirements"
  ];

  meta = with lib; {
    description = "Pip requirements file parser";
    homepage = "https://github.com/davidfischer/requirements-parser";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
