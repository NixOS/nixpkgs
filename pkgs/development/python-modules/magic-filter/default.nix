{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, hatchling
}:

buildPythonPackage rec {
  pname = "magic-filter";
  version = "1.0.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aiogram";
    repo = "magic-filter";
    rev = "refs/tags/v${version}";
    hash = "sha256-MSYIZ/bzngRu6mG3EGblUotSCA+6bi+l3EymFA8NRZA=";
  };

  postPatch = ''
    substituteInPlace magic_filter/__init__.py \
      --replace '"1"' '"${version}"'
  '';

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
