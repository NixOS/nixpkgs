{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cstruct";
  version = "5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "andreax79";
    repo = "python-cstruct";
    rev = "v${version}";
    hash = "sha256-Dwogf0mmxFyBV7tPsuKV6gMZLPSCm7YhzqgJNHpaPFA=";
  };

  pythonImportsCheck = [
    "cstruct"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "C-style structs for Python";
    homepage = "https://github.com/andreax79/python-cstruct";
    changelog = "https://github.com/andreax79/python-cstruct/blob/v${version}/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ tnias ];
  };
}
