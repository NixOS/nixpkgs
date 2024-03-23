{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
, wrapt
}:

buildPythonPackage rec {
  pname = "deprecat";
  version = "2.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjhajharia";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-uAabZAtZDhcX6TfiM0LnrAzxxS64ys+vdodmxO//0x8=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "deprecat"
  ];

  meta = with lib; {
    description = "Decorator to deprecate old python classes, functions or methods";
    homepage = "https://github.com/mjhajharia/deprecat";
    changelog = "https://github.com/mjhajharia/deprecat/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
