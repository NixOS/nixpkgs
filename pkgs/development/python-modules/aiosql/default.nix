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
  version = "9.2";
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
    hash = "sha256-x8ndLVIYAmixH4Fc1DIC1CK8ChYIPZc3b5VFdpT7JO8=";
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
