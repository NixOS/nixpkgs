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
  version = "0.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = pname;
    rev = version;
    hash = "sha256-IY72hDklPkGjb2zo7Wf0MBiPn/jHtyUKW9D0jxA0P54=";
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
