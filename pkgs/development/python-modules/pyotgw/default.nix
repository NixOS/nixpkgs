{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyotgw";
  version = "2.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mvn23";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-XIwBGjvIulKLmYZIorKIJwoHTNOIYYX8US2Na8MZ2LA=";
  };

  propagatedBuildInputs = [
    pyserial-asyncio
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyotgw"
  ];

  meta = with lib; {
    description = "Python module to interact the OpenTherm Gateway";
    homepage = "https://github.com/mvn23/pyotgw";
    changelog = "https://github.com/mvn23/pyotgw/blob/${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
