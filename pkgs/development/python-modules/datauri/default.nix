{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pydantic
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "datauri";
  version = "2.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    rev = "refs/tags/v${version}";
    hash = "sha256-+R1J4IjJ+Vf/+V2kiZyIyAqTAgGLTMJjGePyVRuO5rs=";
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
