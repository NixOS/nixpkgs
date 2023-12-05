{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, openpyxl
, pandas
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "niapy";
  version = "2.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    rev = "refs/tags/${version}";
    hash = "sha256-qstTxUo4jZ8YKbEjtDtSZUvR67VNkBQJdXeERJPOMDw=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    openpyxl
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niapy"
  ];

  meta = with lib; {
    description = "Micro framework for building nature-inspired algorithms";
    homepage = "https://niapy.org/";
    changelog = "https://github.com/NiaOrg/NiaPy/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
