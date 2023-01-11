{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pythonAtLeast
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dacite";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "konradhalas";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+yWvlJcOmqDkHl3JZfPnIV3C4ieSo4FiBvoUZ0+J4N0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dacite"
  ];

  meta = with lib; {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    changelog = "https://github.com/konradhalas/dacite/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
