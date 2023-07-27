{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, hatchling
}:

buildPythonPackage rec {
  pname = "magic-filter";
  version = "1.0.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "magic-filter";
    rev = "v${version}";
    hash = "sha256-mHqq/ci8uMACNutwmxKX1nrl3nTSnSyU2x1VxzWxqzM=";
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
