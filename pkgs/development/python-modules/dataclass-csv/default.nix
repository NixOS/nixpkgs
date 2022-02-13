{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-runner
}:

buildPythonPackage rec {
  pname = "dataclass-csv";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "dfurtado";
    repo = pname;
    rev = version;
    sha256 = "1qv8ybq11d6rszzi7336kbvkf5wjf9lw9yjxj1nrm0rdlnnd0fsw";
  };

  checkInputs = [
    pytestCheckHook
    pytest-runner
  ];

  pythonImportsCheck = [ "dataclass_csv" ];

  meta = with lib; {
    description = "Map CSV data into dataclasses";
    homepage = "https://github.com/dfurtado/dataclass-csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyooru ];
  };
}
