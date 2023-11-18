{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pydantic
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "datauri";
  version = "2.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    rev = "refs/tags/v${version}";
    hash = "sha256-k4tlWRasGa2oQykCD9QJl65UAoZQMJVdyCfqlUBBgqY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "datauri"
  ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  disabledTests = [
    "test_pydantic" # incompatible with pydantic v2
  ];

  meta = with lib; {
    description = "Data URI manipulation made easy.";
    homepage = "https://github.com/fcurella/python-datauri";
    license = licenses.unlicense;
    maintainers = with maintainers; [ yuu ];
  };
}
