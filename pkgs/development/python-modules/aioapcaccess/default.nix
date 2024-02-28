{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "aioapcaccess";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "yuxincs";
    repo = "aioapcaccess";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ig9aQduM9wby3DzPjvbubihopwhdMXHovMo3Id47mRk=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioapcaccess"
  ];

  meta = with lib; {
    description = "Module for working with apcaccess";
    homepage = "https://github.com/yuxincs/aioapcaccess";
    changelog = "https://github.com/yuxincs/aioapcaccess/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
