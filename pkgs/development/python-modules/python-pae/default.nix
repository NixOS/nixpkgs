{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-pae";
  version = "0.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  # Tests are on GitHub
  src = fetchFromGitHub {
    owner = "MatthiasValvekens";
    repo = "python-pae";
    rev = version;
    sha256 = "sha256-D0X2T0ze79KR6Gno4UWpA/XvlkK6Y/jXUtLbzlOKr3E=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "python_pae" ];

  meta = with lib; {
    description = "Pre-authentication encoding (PAE) implementation in Python";
    homepage = "https://github.com/MatthiasValvekens/python-pae";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
