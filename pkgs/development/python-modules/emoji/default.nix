{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "emoji";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "carpedm20";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mcbrlPD2BHjm4WJQZrymv+2wK2NUjv+qvpD/G7iCjwA=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_emojize_name_only"
  ];

  pythonImportsCheck = [
    "emoji"
  ];

  meta = with lib; {
    description = "Emoji for Python";
    homepage = "https://github.com/carpedm20/emoji/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ joachifm ];
  };
}
