{ lib
, buildPythonPackage
, editdistance-s
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, ukkonen
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.5.35";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = "identify";
    rev = "refs/tags/v${version}";
    hash = "sha256-kUBAq9ttIdTLApJ0yW8Yk/NIXpmllApQGpR24wm0PHA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    editdistance-s
    pytestCheckHook
    ukkonen
  ];

  pythonImportsCheck = [
    "identify"
  ];

  meta = with lib; {
    description = "File identification library for Python";
    mainProgram = "identify-cli";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
