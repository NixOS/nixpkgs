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
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mjhajharia";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3Xl/IC+ImFUxxLry15MIIVRf6aR+gA9K5S2IQomkv+o=";
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
