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
  version = "2.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "NiaOrg";
    repo = "NiaPy";
    rev = "refs/tags/${version}";
    hash = "sha256-h3bCitNFjw2WQtsQFR25VJlNVMojdfik+lrPMKwp8Mw=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    openpyxl
    pandas
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "niapy"
  ];

  meta = with lib; {
    description = "Micro framework for building nature-inspired algorithms";
    homepage = "https://niapy.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
