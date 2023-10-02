{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, hatchling
}:

buildPythonPackage rec {
  pname = "magic-filter";
  version = "1.0.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "magic-filter";
    rev = "refs/tags/v${version}";
    hash = "sha256-mfSq47UWOLyEDkAsdHsJuVl/rJ4KgiGPpDL7qSKEfws=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "magic_filter" ];

  meta = with lib; {
    description = "Magic filter based on dynamic attribute getter";
    homepage = "https://github.com/aiogram/magic-filter";
    changelog = "https://github.com/aiogram/magic-filter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
