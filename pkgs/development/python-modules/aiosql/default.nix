{ lib
, buildPythonPackage
, fetchFromGitHub
, pg8000
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, sphinx-rtd-theme
, sphinxHook
}:

buildPythonPackage rec {
  pname = "aiosql";
  version = "9.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  outputs = [
    "doc"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "nackjicholson";
    repo = "aiosql";
    rev = "refs/tags/${version}";
    hash = "sha256-7bCJykE+7/eA1h4L5MyH/zVPZVMt7cNLXZSWq+8mPtY=";
  };

  sphinxRoot = "docs/source";

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [
    pg8000
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiosql"
  ];

  meta = with lib; {
    description = "Simple SQL in Python";
    homepage = "https://nackjicholson.github.io/aiosql/";
    changelog = "https://github.com/nackjicholson/aiosql/releases/tag/${version}";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ kaction ];
  };
}
