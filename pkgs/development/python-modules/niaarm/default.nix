{ lib
, buildPythonPackage
, fetchFromGitHub
, niapy
, nltk
, pandas
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "NiaARM";
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = pname;
    rev = version;
    sha256 = "sha256-tO/9dDgPPL5fkFm/U9AhyydXW+dtem+Q3H2uKPAXzno=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    niapy
    nltk
    pandas
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niaarm"
  ];

  meta = with lib; {
    description = "A minimalistic framework for Numerical Association Rule Mining";
    homepage = "https://github.com/firefly-cpp/NiaARM";
    license = licenses.mit;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}
