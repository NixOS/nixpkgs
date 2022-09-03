{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastcore";
  version = "1.5.22";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-pJGyfo+7Sz4IxurkAo+51veN+o6gHAqBor5SLXERNdo=";
  };

  propagatedBuildInputs = [
    packaging
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "fastcore"
  ];

  meta = with lib; {
    description = "Python module for Fast AI";
    homepage = "https://github.com/fastai/fastcore";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
