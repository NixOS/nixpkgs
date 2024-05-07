{ lib
, buildPythonPackage
, fetchFromGitHub
, packaging
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastcore";
  version = "1.5.33";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Zf6bNHMiYEJrLPU1w7OvEavdKIageG+sJ9W8OE/ET0M=";
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
    changelog = "https://github.com/fastai/fastcore/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
