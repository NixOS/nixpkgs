{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "metar";
  version = "1.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-metar";
    repo = "python-metar";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZDjlXcSTUcSP7oRdhzLpXf/fLUA7Nkc6nj2I6vovbHg=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "metar"
  ];

  meta = with lib; {
    description = "Python parser for coded METAR weather reports";
    homepage = "https://github.com/python-metar/python-metar";
    changelog = "https://github.com/python-metar/python-metar/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ bsd1 ];
    maintainers = with maintainers; [ fab ];
  };
}
