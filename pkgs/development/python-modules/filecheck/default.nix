{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "filecheck";
  version = "0.0.24";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mull-project";
    repo = "FileCheck.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-VbMlCqGd3MVpj0jEKjSGC2L0s/3e/d53b+2eZcXZneo=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "filecheck"
  ];

  meta = with lib; {
    changelog = "https://github.com/mull-project/FileCheck.py/releases/tag/v${version}";
    homepage = "https://github.com/mull-project/FileCheck.py";
    license = licenses.asl20;
    description = "Python port of LLVM's FileCheck, flexible pattern matching file verifier";
    maintainers = with maintainers; [ yorickvp ];
  };
}
