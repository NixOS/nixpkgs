{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "5.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tkem";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1B/vAfGroGABijMWuiKmIkMyjNSp2B3VkH7s1NMlbw0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cachetools"
  ];

  meta = with lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    changelog = "https://github.com/tkem/cachetools/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
